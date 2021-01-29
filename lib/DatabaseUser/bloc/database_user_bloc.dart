import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:free_movies/DatabaseUser/model/database_user.dart';
import 'package:free_movies/authentication/authentication.dart';

import '../database_user.dart';

class DatabaseUserBloc extends Cubit<DatabaseUser> {
  final AuthenticationBloc authBloc;
  StreamSubscription<AuthenticationState> _authStateListenerSubscription;
  StreamSubscription<DatabaseUser> _databaseUserListenerSubscription;

  DatabaseUserBloc([this.authBloc])
      : assert(authBloc != null),
        super(null) {
    _authStateListenerSubscription = authBloc.listen(authStateListener);
  }
  void authStateListener(AuthenticationState state) async {
    _databaseUserListenerSubscription?.cancel();
    if (state.status == AuthenticationStatus.authenticated &&
        state.user != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(state.user.id)
          .get()
          .then((value) async {
        if (!value.exists) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(state.user.id)
              .set(
              DatabaseUser.fromUser(state.user)
                  .copyWith(userSetting: UserSetting.initial())
                  .toJson(),
              SetOptions(merge: true));
        }
      });

      _databaseUserListenerSubscription = FirebaseFirestore.instance
          .collection('users')
          .doc(state.user.id)
          .snapshots()
          .map((event) =>
      event.exists ? DatabaseUser.fromJson(event.data()) : null)
          .listen(databaseUserListener);
    } else {
      emit(null);
    }
  }

  void databaseUserListener(DatabaseUser databaseUser) {
    if (databaseUser != state) {
      emit(databaseUser);
    }
  }

  @override
  Future<void> close() {
    _databaseUserListenerSubscription?.cancel();
    _authStateListenerSubscription?.cancel();
    // TODO: implement close
    return super.close();
  }
}
