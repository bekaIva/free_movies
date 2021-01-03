import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:free_movies/Player/model/exceptions.dart';
import 'package:free_movies/Player/model/source.dart';
import 'package:video_player/video_player.dart';

abstract class State extends Equatable {}

class InitialState extends State {
  @override
  List<Object> get props => [];
}

class SourceLoading extends State {
  final Source source;
  SourceLoading({this.source});
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class SourceLoaded extends State {
  final Source source;
  final VideoPlayerController controller;
  SourceLoaded({this.source, @required this.controller})
      : assert(controller != null);
  @override
  // TODO: implement props
  List<Object> get props => [source, controller];
}

class ControllerValueChanged extends State {
  final VideoPlayerController controller;
  final VideoPlayerValue videoPlayerValue;
  ControllerValueChanged([this.controller, this.videoPlayerValue]);
  @override
  // TODO: implement props
  List<Object> get props => [videoPlayerValue];
}

class ExceptionOccoured extends State implements Exception {
  final Exception exception;
  ExceptionOccoured([this.exception]);
  @override
  // TODO: implement props
  List<Object> get props => [exception];
}

abstract class Event extends Equatable {}

class LoadSource extends Event {
  final Source source;
  LoadSource({@required this.source}) : assert(source != null);
  @override
  // TODO: implement props
  List<Object> get props => [source];
}

class PlayerBloc extends Bloc<Event, State> {
  VideoPlayerController _currentController;
  PlayerBloc() : super(InitialState());

  @override
  void onError(Object error, StackTrace stackTrace) {
    // TODO: implement onError
    emit(ExceptionOccoured(error));
  }

  @override
  Stream<State> mapEventToState(Event event) async* {
    if (event is LoadSource) {
      yield SourceLoading(source: event.source);
      var controller = await _loadSource(event);
      yield (SourceLoaded(controller: controller, source: event.source));
    }
  }

  Future<VideoPlayerController> _loadSource(LoadSource event) async {
    VideoPlayerController controller;
    switch (event.source.type) {
      case DataSourceType.asset:
        controller = VideoPlayerController.asset(event.source.path);
        break;
      case DataSourceType.network:
        controller = VideoPlayerController.network(event.source.path);
        break;
      case DataSourceType.file:
        controller = VideoPlayerController.file(File(event.source.path));
        break;
    }
    if (controller != null) {
      await controller.initialize();
      _currentController?.removeListener(_controllerListener);
      _currentController?.dispose();
      _currentController = controller;
      _currentController.addListener(_controllerListener);
      controller.play();
      return controller;
    } else {
      throw new SourceLoadFailed(
          source: event.source, message: 'Source initialization failed');
    }
  }

  void _controllerListener() {
    emit(ControllerValueChanged(_currentController, _currentController.value));
  }

  @override
  Future<void> close() {
    _currentController?.dispose();
    return super.close();
  }
}
