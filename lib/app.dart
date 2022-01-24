import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:free_movies/Api/TubiApi.dart';
import 'package:free_movies/GlobalSettings/global_settings_bloc.dart';
import 'package:free_movies/blocs/interstitialBloc.dart';
import 'package:free_movies/home/home.dart';

import 'home/bloc/search_bloc/search_bloc.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => InterstitialBloc(),
          lazy: false,
        ),
        BlocProvider(create: (_) => GlobalSettingsBloc()),
      ],
      child: RepositoryProvider<TubiApi>(
        create: (context) => TubiApi(context.read<GlobalSettingsBloc>()),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => SearchBloc(context.read<TubiApi>()),
            ),
          ],
          child: MyAppView(),
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
    return BlocListener<InterstitialBloc, InterstitialState>(
        listener: (context, state) {
          print(state);
          if (state == null &&
              (context.read<GlobalSettingsBloc>().state?.adsEnabled ?? false)) {
            context.read<InterstitialBloc>().load();
          }
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: HomePage(),
          navigatorKey: _navigatorKey,
        ));
  }
}
