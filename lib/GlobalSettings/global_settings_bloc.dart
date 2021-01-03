import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:free_movies/GlobalSettings/models/global_setting.dart';

class GlobalSettingsBloc extends Cubit<GlobalSetting> {
  StreamSubscription _settingsListener;
  GlobalSettingsBloc() : super(GlobalSetting.initial()) {
    _settingsListener = FirebaseFirestore.instance
        .collection('appdata')
        .doc('settings')
        .snapshots()
        .map((event) => event.exists
            ? GlobalSetting.fromJson(event.data())
            : GlobalSetting.initial())
        .listen((event) {
      if (event != null) emit(event);
    });
  }
  @override
  Future<void> close() {
    _settingsListener.cancel();
    return super.close();
  }
}
