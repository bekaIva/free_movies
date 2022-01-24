import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:free_movies/bloc_observer/main_bloc_observer.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MobileAds.instance.initialize();
  EquatableConfig.stringify = kDebugMode;
  Bloc.observer = MainBlocObserver();
  runApp(MyApp());
}

String getBannerAdUnitId() {
  if (Platform.isIOS) {
    //ca-app-pub-3909212246838265/6731706959
    return 'ca-app-pub-3940256099942544/2934735716';
  } else if (Platform.isAndroid) {
    if (kReleaseMode) return 'ca-app-pub-3909212246838265/5645010474';
    if (kDebugMode) return 'ca-app-pub-3940256099942544/6300978111';
  }
  return null;
}

String getInterstitialAdUnitId() {
  if (Platform.isIOS) {
    //ca-app-pub-3909212246838265/2010890983
    return 'ca-app-pub-3940256099942544/4411468910';
  } else if (Platform.isAndroid) {
    if (kReleaseMode) return 'ca-app-pub-3909212246838265/9336843476';
    if (kDebugMode) return 'ca-app-pub-3940256099942544/1033173712';
  }
  return null;
}
