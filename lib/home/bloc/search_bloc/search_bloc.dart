import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/animation.dart';
import 'package:free_movies/Api/TubiApi.dart';
import 'package:free_movies/home/model/home_response.dart';

abstract class SearchState extends Equatable {}

class EmptyState extends SearchState {
  @override
  List<Object> get props => [];
}

class LoadingState extends SearchState {
  @override
  List<Object> get props => [];
}

class LoadedState extends SearchState {
  final List<Content> results;
  LoadedState({this.results});
  @override
  List<Object> get props => [results];
}

class ErrorState extends SearchState {
  final dynamic exception;
  ErrorState({this.exception});
  @override
  List<Object> get props => [];
}

class SearchBloc extends Cubit<SearchState> {
  TubiApi _tubiApi;
  SearchBloc([this._tubiApi]) : super(EmptyState());

  Future<void> search(String query) async {
    if (query.isEmpty) {
      emit(EmptyState());
      return;
    }
    emit(LoadingState());
    try {
      var res = await _tubiApi.search(query);
      if (res.isEmpty) {
        emit(EmptyState());
      } else {
        emit(LoadedState(results: res));
      }
    } catch (e) {
      emit(ErrorState(exception: e));
    }
  }
}
