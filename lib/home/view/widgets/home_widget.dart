import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:free_movies/Api/TubiApi.dart';
import 'package:free_movies/constants/Constants.dart';
import 'package:free_movies/container/container.dart';
import 'package:free_movies/home/bloc/home_page_bloc.dart';
import 'package:free_movies/home/model/home_response.dart' as resopnse;
import 'package:free_movies/widgets/ContainerGroupWidget.dart';
import 'package:free_movies/widgets/HorizontalMoviesList.dart';
import 'package:free_movies/widgets/SliderMovies.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget>
    with AutomaticKeepAliveClientMixin {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  HomePageBloc _bloc;
  @override
  void initState() {
    _bloc =context.read<HomePageBloc>();
    _bloc.add(Load());
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
    super.build(context);
    return BlocProvider.value(
        value: _bloc,
        child: Theme(data: ThemeData(primarySwatch: Colors.brown),
          child: SmartRefresher(
            onRefresh: () {
              _bloc.add(Load());
            },
            controller: _refreshController,
            child: SingleChildScrollView(
              child: BlocBuilder<HomePageBloc, HomePageResponse>(
                builder: (context, state) {
                  if (state.mainContentStatus != HomePageResponseStatus.loading &&
                      state.secondaryContentStatus !=
                          HomePageResponseStatus.loading &&
                      _refreshController.isRefresh) {
                    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                      _refreshController.loadComplete();
                      _refreshController.refreshCompleted();
                    });
                  }
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (state.mainContentStatus ==
                          HomePageResponseStatus.loading)
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(kHeaderYelowColor),
                        ),
                      if (state.mainContentStatus ==
                          HomePageResponseStatus.loaded) ...[
                        SliderMovies(
                          response: state.mainContentResponse,
                        ),
                        ContainerGroupWidget(
                          containers: Map.fromEntries(
                            state.mainContentResponse.containers
                                .skip(1)
                                .toList()
                                .map(
                                  (c) => MapEntry(
                                    c,
                                    c.children
                                        .map((ch) => state
                                            .mainContentResponse.contents[ch])
                                        .toList(),
                                  ),
                                ),
                          ),
                        ),
                      ],
                      if (state.secondaryContentStatus ==
                          HomePageResponseStatus.loading)
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(kHeaderYelowColor),
                        ),
                      if (state.secondaryContentStatus ==
                          HomePageResponseStatus.loaded)
                        ContainerGroupWidget(
                          containers: Map.fromEntries(
                            state.secondaryContentResponse.containers.map(
                              (c) => MapEntry(
                                c,
                                c.children
                                    .map((ch) => state
                                        .secondaryContentResponse.contents[ch])
                                    .toList(),
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
        ));
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
