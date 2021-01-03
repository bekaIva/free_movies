import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:free_movies/DatabaseUser/model/database_user.dart';
import 'package:free_movies/authentication/authentication.dart';

class DatabaseUserBloc extends Cubit<DatabaseUser> {
  final AuthenticationBloc authBloc;
  StreamSubscription<AuthenticationState> _authStateListenerSubscription;
  StreamSubscription<DatabaseUser> _databaseUserListenerSubscription;

  DatabaseUserBloc([this.authBloc])
      : assert(authBloc != null),
        super(null) {
    _authStateListenerSubscription = authBloc.listen(authStateListener);
  }
  void authStateListener(AuthenticationState state) {
    if (state.status != AuthenticationStatus.authenticated ||
        state.user == null) {
      _databaseUserListenerSubscription?.cancel();
      emit(null);
    }
    _databaseUserListenerSubscription?.cancel();
    _databaseUserListenerSubscription = FirebaseFirestore.instance
        .collection('users')
        .doc(state.user.id)
        .snapshots()
        .map((event) => DatabaseUser.fromJson(event.data()))
        .listen(databaseUserListener);
  }

  void databaseUserListener(DatabaseUser databaseUser) {
    if (databaseUser != state) emit(databaseUser);
  }

  @override
  Future<void> close() {
    _databaseUserListenerSubscription?.cancel();
    _authStateListenerSubscription?.cancel();
    // TODO: implement close
    return super.close();
  }
}
