import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:free_movies/Api/TubiApi.dart';
import 'package:free_movies/home/model/home_response.dart' as homeResponse;

class ContainerBloc extends Bloc<ContainerEvent, ContainerState> {
  final TubiApi _tubiApi;
  final homeResponse.Container container;
  List<homeResponse.Content> _contents = [];
  ContainerBloc([this._tubiApi, this.container]) : super(EmptyState());

  List<homeResponse.Content> getContainerContents(
      homeResponse.SingleContainerResponse container) {
    var res = container.contents.values.toList();
    return res;
  }

  @override
  Stream<ContainerState> mapEventToState(ContainerEvent event) async* {
    try {
      if (event is Load) {
        _contents = [];
        yield StateLoading(contents: _contents, isMoreAvailable: false);
        var response = await _tubiApi.loadContainer(
          container: container,
        );
        _contents.addAll(getContainerContents(response));
        yield StateLoaded(_contents, (response.contents?.length ?? 0) > 0);
      }
      if (event is LoadNext) {
        yield StateLoading(contents: _contents, isMoreAvailable: false);
        var response = await _tubiApi.loadContainer(
            container: container, cursor: _contents.length);
        _contents.addAll(getContainerContents(response));
        yield StateLoaded(_contents, (response.contents?.length ?? 0) > 0);
      }
    } catch (e) {
     yield StateLoaded(_contents,false);
    }
  }

}

abstract class ContainerEvent extends Equatable {}

class Load extends ContainerEvent {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoadNext extends ContainerEvent {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

abstract class ContainerState extends Equatable {}

class EmptyState extends ContainerState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class StateLoading extends StateLoaded {
  StateLoading({List<homeResponse.Content> contents, bool isMoreAvailable})
      : super(contents, isMoreAvailable);
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class StateLoaded extends ContainerState {
  final bool isMoreAvailable;
  final List<homeResponse.Content> contents;
  StateLoaded([this.contents, this.isMoreAvailable]);

  @override
  List<Object> get props => [contents];
}
