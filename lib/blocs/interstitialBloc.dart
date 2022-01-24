import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:free_movies/main.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

abstract class InterstitialState {}

class AdLoaded extends InterstitialState {}

class AdOpened extends InterstitialState {}

class InterstitialBloc extends Cubit<InterstitialState> {
  InterstitialAd _interstitialAd;
  InterstitialBloc() : super(null) {
    load();
  }
  Future<void> showAd() async {
    _interstitialAd?.show();
  }

  Future<void> load() async {
    await InterstitialAd.load(
        adUnitId: getInterstitialAdUnitId(),
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            // Keep a reference to the ad so you can show it later.
            this._interstitialAd = ad;
            _interstitialAd.fullScreenContentCallback =
                FullScreenContentCallback(
                    onAdShowedFullScreenContent: (InterstitialAd ad) {
              print('%ad onAdShowedFullScreenContent.');
              emit(null);
            }, onAdDismissedFullScreenContent: (InterstitialAd ad) {
              print('$ad onAdDismissedFullScreenContent.');
              _interstitialAd.dispose();
              emit(null);
            }, onAdFailedToShowFullScreenContent:
                        (InterstitialAd ad, AdError error) {
              print('$ad onAdFailedToShowFullScreenContent: $error');
              _interstitialAd.dispose();
              emit(null);
            }, onAdImpression: (InterstitialAd ad) {
              print('$ad impression occurred.');
              emit(null);
            });
            emit(AdLoaded());
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error');
          },
        ));
  }
}
