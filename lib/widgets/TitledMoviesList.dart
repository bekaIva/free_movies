import 'package:flutter/material.dart';
import 'package:free_movies/constants/Constants.dart';
import 'package:free_movies/home/model/home_response.dart' as response;

import 'HorizontalMoviesList.dart';

class TitledMoviesList extends StatelessWidget {
  final List<response.Content> movies;
  final String title;
  const TitledMoviesList({@required this.movies, @required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 307,
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          backgroundColor: kBackgroundColor,
          title: Text(
            title,
          ),
        ),
        body: HorizontalMoviesList(
          movies: movies,
        ),
      ),
    );
  }
}
