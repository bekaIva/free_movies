import 'package:flutter/material.dart';
import 'package:free_movies/constants/Constants.dart';
import 'package:free_movies/home/model/home_response.dart' as response;

import 'HorizontalMoviesList.dart';

class SimilarMovies extends StatefulWidget {
  List<response.Content> similarContents;
  SimilarMovies({this.similarContents});
  @override
  _SimilarMoviesState createState() => _SimilarMoviesState();
}

class _SimilarMoviesState extends State<SimilarMovies> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10, top: 20),
          child: Text(
            'SIMILAR MOVIES',
            style: TextStyle(
                color: kTitleColor, fontWeight: FontWeight.w500, fontSize: 12),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          height: 270,
          padding: EdgeInsets.only(left: 10),
          child: HorizontalMoviesList(
            movies: widget.similarContents,
          ),
        )
      ],
    );
  }
}
