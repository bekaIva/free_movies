part of 'home_page_bloc.dart';

enum HomePageResponseStatus { none, loading, loaded, error }

class HomePageResponse {
  HomePageResponse(
      {this.mainContentResponse,
      this.mainContentStatus,
      this.secondaryContentResponse,
      this.secondaryContentStatus});
  HomePageResponse.initial()
      : mainContentStatus = HomePageResponseStatus.none,
        mainContentResponse = null,
        secondaryContentStatus = HomePageResponseStatus.none,
        secondaryContentResponse = null;

  HomePageResponse copyWith(
          {HomePageResponseStatus mainContentStatus,
          HomeResponse mainContentResponse,
          HomePageResponseStatus secondaryContentStatus,
          HomeResponse secondaryContentResponse}) =>
      HomePageResponse(
          mainContentResponse: mainContentResponse ?? this.mainContentResponse,
          mainContentStatus: mainContentStatus ?? this.mainContentStatus,
          secondaryContentResponse:
              secondaryContentResponse ?? this.secondaryContentResponse,
          secondaryContentStatus:
              secondaryContentStatus ?? this.secondaryContentStatus);

  final HomePageResponseStatus mainContentStatus;
  final HomeResponse mainContentResponse;

  final HomePageResponseStatus secondaryContentStatus;
  final HomeResponse secondaryContentResponse;
}
