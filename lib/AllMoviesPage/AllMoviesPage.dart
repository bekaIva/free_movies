import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:free_movies/Api/TubiApi.dart';
import 'package:free_movies/constants/Constants.dart';
import 'package:free_movies/home/model/home_response.dart' as Response;
import 'package:free_movies/widgets/ContainerGroupWidget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AllMoviesPage extends StatefulWidget {
  static Route get allMoviesPageRoute => MaterialPageRoute(
      builder: (context) => BlocProvider(
            create: (context) => MoviesListBloc(context.read<TubiApi>()),
            child: AllMoviesPage(),
          ));
  @override
  _AllMoviesPageState createState() => _AllMoviesPageState();
}

class _AllMoviesPageState extends State<AllMoviesPage> {
  @override
  Widget build(BuildContext context) {
    return MoviesList(
      mode: ContentMode.movie,
    );
  }
}

class MoviesListBloc extends Bloc<MoviesListEvent, MoviesListState> {
  ContentMode _mode;
  final TubiApi _tubiApi;
  MoviesListBloc(this._tubiApi) : super(EmptyState());

  @override
  Stream<MoviesListState> mapEventToState(MoviesListEvent event) async* {
    if (event is SetContentModeEvent) {
      _mode = event.mode;
    }
    if (event is LoadEvent) {
      yield LoadingState();
      var response = await _tubiApi.loadHomeScreen(
          groupStart: 5, groupSize: -1, contentMode: _mode);
      yield LoadedState(response);
    }
  }
}

abstract class MoviesListState extends Equatable {}

class EmptyState extends MoviesListState {
  @override
  List<Object> get props => [];
}

class LoadingState extends MoviesListState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoadedState extends MoviesListState {
  final Response.HomeResponse response;
  LoadedState(this.response);

  @override
  // TODO: implement props
  List<Object> get props => [response];
}

abstract class MoviesListEvent extends Equatable {}

class LoadEvent extends MoviesListEvent {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class SetContentModeEvent extends MoviesListEvent {
  final ContentMode mode;
  SetContentModeEvent(this.mode);
  @override
  // TODO: implement props
  List<Object> get props => [mode];
}

class MoviesList extends StatefulWidget {
  final ContentMode mode;
  MoviesList({this.mode});
  @override
  _MoviesListState createState() => _MoviesListState();
}

class _MoviesListState extends State<MoviesList>
    with AutomaticKeepAliveClientMixin {
  MoviesListBloc _bloc;
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  @override
  void initState() {
    _bloc = context.read<MoviesListBloc>();
    _bloc.add(SetContentModeEvent(widget.mode));
    if (_bloc.state is EmptyState) _bloc.add(LoadEvent());
    super.initState();
  }
@override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
   return SmartRefresher(enablePullDown: true,
      onRefresh: () {
        _bloc.add(LoadEvent());
      },
      controller: _refreshController,
      child: SingleChildScrollView(
        child: BlocBuilder<MoviesListBloc, MoviesListState>(
          builder: (context, state) {
            if(!(state is LoadingState) && _refreshController.isRefresh)
            {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  _refreshController.loadComplete();
                  _refreshController.refreshCompleted();
                });

            }
            return Stack(
              children: [

                if (state is LoadedState)
                  () {
                    var contents = state.response.containers
                        .toList()
                        .map(
                          (e) => MapEntry(
                            e,
                            e.children
                                .map((child) => state.response.contents[child])
                                .toList(),
                          ),
                        )
                        .toList();
                    return Column(children: contents.map((e) => ContainerGroupWidget(
                      containers: Map.fromEntries([e]),
                    )).toList(),);
                    return ListView.builder(
                      itemCount: contents.length,
                      itemBuilder: (context, index) {
                        return ContainerGroupWidget(
                          containers: Map.fromEntries([contents[index]]),
                        );
                      },
                    );
                  }(),
                Container(child: Center(child: state is LoadingState?CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(kYelowTitleColor),
            ):Container()),),

              ],
            );
          },
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
