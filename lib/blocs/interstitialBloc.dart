import 'package:admob_flutter/admob_flutter.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:free_movies/main.dart';

abstract class InterstitialState {}

class AdLoaded extends InterstitialState {}

class AdOpened extends InterstitialState {}

class InterstitialBloc extends Cubit<InterstitialState> {
  AdmobInterstitial interstitialAd;
  InterstitialBloc() : super(null) {
    interstitialAd = AdmobInterstitial(
      adUnitId: getInterstitialAdUnitId(),
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) interstitialAd.load();
        handleEvent(event, args, 'Interstitial');
      },
    );
    interstitialAd.load();
  }
  Future<void> showAd() async {
    if (await interstitialAd.isLoaded) {
      interstitialAd.show();
    }
  }

  void handleEvent(
      AdmobAdEvent event, Map<String, dynamic> args, String adType) {
    print(event);
    switch (event) {
      case AdmobAdEvent.loaded:
        emit(AdLoaded());
        break;
      case AdmobAdEvent.opened:
        emit(AdOpened());
        break;
      case AdmobAdEvent.closed:
        break;
      case AdmobAdEvent.failedToLoad:
        break;
      default:
    }
    load();
  }

  Future<void> load() async {
    await Future.delayed(Duration(milliseconds: 400));
    if (!await interstitialAd.isLoaded) {
      interstitialAd.load();
    }
  }
}
