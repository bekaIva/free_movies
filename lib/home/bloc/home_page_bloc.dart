import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:free_movies/Api/TubiApi.dart';
import 'package:free_movies/home/model/home_response.dart';

part 'package:free_movies/home/bloc/HomePageEvent.dart';
part 'package:free_movies/home/bloc/HomePageState.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageResponse> {
  TubiApi _tubiApi;
  HomePageBloc([this._tubiApi]) : super(HomePageResponse.initial());

  @override
  Stream<HomePageResponse> mapEventToState(HomePageEvent event) async* {
    if (event is Load) {
      yield HomePageResponse(
        mainContentStatus: HomePageResponseStatus.loading,
        secondaryContentStatus: HomePageResponseStatus.loading,
      );
      var mainFuture = _tubiApi.loadHomeScreen(
          includeEmptyQueue: true,
          limit: 40,
          expand: 2,
          includeVideoInGrid: false,
          groupStart: 0,
          groupSize: 5);
      var secondFuture = _tubiApi.loadHomeScreen(
          includeEmptyQueue: true,
          limit: 40,
          expand: 2,
          includeVideoInGrid: false,
          groupStart: 5,
          groupSize: -1);
      try {
        var res = await mainFuture;
        yield state.copyWith(
            mainContentStatus: HomePageResponseStatus.loaded,
            mainContentResponse: res);
      } catch (e) {
        yield state.copyWith(
          mainContentStatus: HomePageResponseStatus.error,
        );
      }
      try {
        var res = await secondFuture;
        yield state.copyWith(
            secondaryContentStatus: HomePageResponseStatus.loaded,
            secondaryContentResponse: res);
      } catch (e) {
        yield state.copyWith(
          secondaryContentStatus: HomePageResponseStatus.error,
        );
      }
    }
  }
}
