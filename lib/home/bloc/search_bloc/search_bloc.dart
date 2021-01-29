import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/animation.dart';
import 'package:free_movies/Api/TubiApi.dart';

abstract class SearchState extends Equatable
{

}
class EmptyState extends SearchState
{
  @override
  List<Object> get props => [];
}
class LoadingState extends SearchState
{
  @override
  List<Object> get props => [];
}
class LoadedState extends SearchState
{
  @override
  List<Object> get props => [];
}
class ErrorState extends SearchState
{
  @override
  List<Object> get props => [];
}

class SearchBloc extends Cubit<SearchState>
{
  TubiApi _tubiApi;
  SearchBloc([this._tubiApi]) : super(EmptyState());

  Future<void> search(String query)async
  {
    var res = await _tubiApi.search(query);

  }


}