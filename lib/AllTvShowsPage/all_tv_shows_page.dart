import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:free_movies/AllMoviesPage/AllMoviesPage.dart';
import 'package:free_movies/Api/TubiApi.dart';


class AllTvShowsPage extends StatefulWidget {
  static Route get allMoviesPageRoute => MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (context) => MoviesListBloc(context.read<TubiApi>()),
        child: AllTvShowsPage(),
      ));
  @override
  _AllTvShowsPageState createState() => _AllTvShowsPageState();
}

class _AllTvShowsPageState extends State<AllTvShowsPage> {
  @override
  Widget build(BuildContext context) {
    return MoviesList(
      mode: ContentMode.tv,
    );
  }
}