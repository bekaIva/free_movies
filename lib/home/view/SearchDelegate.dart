import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:free_movies/home/bloc/search_bloc/search_bloc.dart';

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
  Widget buildResults(BuildContext context) {
    _bloc.search(query);
    return BlocBuilder<SearchBloc, SearchState>(cubit: _bloc,
      builder: (context, state) {
        if (state is EmptyState) {
          return Text('Nothing to show');
        }
        if (state is LoadingState) {
          return CircularProgressIndicator();
        }
        if (state is LoadedState) {
          return Container();
        }
        return Text('error');
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Text('test');
    // TODO: implement buildSuggestions
  }
}
