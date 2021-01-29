import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:free_movies/Api/TubiApi.dart';
import 'package:free_movies/DatabaseUser/database_user.dart';
import 'package:free_movies/GlobalSettings/global_settings_bloc.dart';
import 'package:free_movies/home/home.dart';
import 'package:free_movies/themes/themes.dart';

import 'authentication/bloc/authentication_bloc.dart';
import 'constants/Constants.dart';
import 'home/bloc/search_bloc/search_bloc.dart';

class MyApp extends StatelessWidget {
  final AuthenticationRepository authenticationRepository;

  MyApp({@required this.authenticationRepository});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authenticationRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (_) => AuthenticationBloc(
                  authenticationRepository: authenticationRepository)),
          BlocProvider(create: (_) => GlobalSettingsBloc()),
        ],
        child: RepositoryProvider<TubiApi>(
          create: (context) => TubiApi(context.read<GlobalSettingsBloc>()),
          child: MultiBlocProvider(providers: [
            BlocProvider(
              create: (context) =>
                  DatabaseUserBloc(context.read<AuthenticationBloc>()),
              lazy: false,
            ),
            BlocProvider(
              create: (context) => SearchBloc(context.read<TubiApi>()),
            ),
          ],
            child: MyAppView(),
          ),
        ),
      ),
    );
  }
}

class MyAppView extends StatefulWidget {
  @override
  _MyAppViewState createState() => _MyAppViewState();
}

class _MyAppViewState extends State<MyAppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  NavigatorState get _navigator => _navigatorKey.currentState;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          child: child,
          listener: (context, state) {
            switch (state.status) {
              case AuthenticationStatus.authenticated:
                break;
              case AuthenticationStatus.unauthenticated:
                break;
            }
          },
        );
      },
    );
  }
}
