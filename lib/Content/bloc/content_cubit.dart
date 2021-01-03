import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:free_movies/Api/TubiApi.dart';
import 'package:free_movies/home/model/home_response.dart';

part 'content_state.dart';

class ContentCubit extends Cubit<ContentState> {
  TubiApi tubiApi;
  ContentCubit(
    Content content, {
    @required this.tubiApi,
  })  : assert(tubiApi != null),
        super(ContentInitial(content: content));
  Future<void> updateContent(Content content) async {
    emit(ContentLoading(content));
    tubiApi
        .updateContent(content.type == 's' ? '0${content.id}' : content.id)
        .then((value) {
      emit(ContentLoaded(value));
    }, onError: (e) {
      addError(ContentError(content, exception: e));
    });
  }

  @override
  void onError(Object error, StackTrace stackTrace) {
    emit(error);
  }
}
