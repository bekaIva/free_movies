import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:free_movies/constants/Constants.dart';
import 'package:free_movies/home/bloc/search_bloc/search_bloc.dart';
import 'package:free_movies/widgets/HorizontalMoviesList.dart';

class HomeSearchDelegate extends SearchDelegate {
  SearchBloc _bloc;
  HomeSearchDelegate(this._bloc);
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      primaryColor: kLigthBackgroundColor,
      textTheme: TextTheme(headline6: TextStyle(color: Colors.white)),
      primaryIconTheme: IconThemeData(
        color: Colors.white,
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle:
            Theme.of(context).textTheme.headline6.copyWith(color: Colors.white),
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    _bloc.search(query);
    return Container(
      color: kBackgroundColor,
      child: BlocBuilder<SearchBloc, SearchState>(
        bloc: _bloc,
        builder: (context, state) {
          if (state is EmptyState) {
            return TextResult('Ntohing found');
          }
          if (state is LoadingState) {
            return Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(kYelowTitleColor)));
          }
          if (state is LoadedState) {
            return GridView.builder(
              itemCount: state.results.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, childAspectRatio: .5),
              itemBuilder: (context, index) {
                return MovieWidget(
                  movie: state.results[index],
                  titleColor: Colors.white,
                );
              },
            );
          }
          if (state is ErrorState) {
            return TextResult('Error');
          }
          return TextResult('Nothing to show');
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      color: kBackgroundColor,
    );
    // TODO: implement buildSuggestions
  }
}

class TextResult extends StatelessWidget {
  final String text;
  TextResult(this.text);
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
