import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:free_movies/Content/bloc/content_cubit.dart';
import 'package:free_movies/GlobalSettings/global_settings_bloc.dart';
import 'package:free_movies/GlobalSettings/models/global_setting.dart';
import 'package:free_movies/Player/player_view.dart';
import 'package:free_movies/blocs/interstitialBloc.dart';
import 'package:free_movies/constants/Constants.dart';
import 'package:free_movies/home/model/home_response.dart' as response;
import 'package:free_movies/main.dart';
import 'package:free_movies/widgets/ChildWidget.dart';
import 'package:free_movies/widgets/HorizontalMoviesList.dart';
import 'package:free_movies/widgets/casts.dart';
import 'package:free_movies/widgets/movie_info.dart';
import 'package:sliver_fab/sliver_fab.dart';

class ContentForm extends StatefulWidget {
  @override
  _ContentFormState createState() => _ContentFormState();
}

class _ContentFormState extends State<ContentForm> {
  bool adShown = false;
  var seasonsPageController =
      PageController(keepPage: true, viewportFraction: .3, initialPage: 0);
  int selectedSeason;
  ValueNotifier<AdmobAdEvent> admobEvemt =
      ValueNotifier<AdmobAdEvent>(AdmobAdEvent.closed);
  ContentCubit _cubit;
  @override
  void initState() {
    _cubit = context.read<ContentCubit>();
    if (_cubit.state is ContentInitial) {
      _cubit.updateContent((_cubit.state as ContentInitial).content);
    }
    if (context.read<GlobalSettingsBloc>().state.adsEnabled) {
      if (context.read<InterstitialBloc>().state is AdLoaded) {
        context.read<InterstitialBloc>().showAd();
      }

      //todo show interstitial
    }
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContentCubit, ContentState>(
      buildWhen: (previous, current) => current is ContentStates,
      builder: (context, state) {
        return BlocBuilder<GlobalSettingsBloc, GlobalSetting>(
          builder: (context, setting) {
            return Scaffold(
              backgroundColor: kBackgroundColor,
              body: Stack(
                children: [
                  ValueListenableBuilder<AdmobAdEvent>(
                    valueListenable: admobEvemt,
                    child: SliverFab(
                      expandedHeight: 200,
                      floatingPosition: FloatingPosition(
                        right: 20,
                      ),
                      floatingWidget: Builder(
                        builder: (context) {
                          if (state is ContentInitial)
                            return errorWidgetBuilder(state.content);
                          if (state is ContentLoading) return loadingWidget();
                          if (state is ContentError)
                            return errorWidgetBuilder(state.content);
                          if (state is ContentLoaded &&
                              (state.content.videoResources?.length ?? 0) > 0 &&
                              (state.content.url?.length ?? 0) > 0)
                            return FloatingActionButton(
                              elevation: 2,
                              highlightElevation: 4,
                              onPressed: () {
                                Navigator.of(context)
                                    .push(PlayerPage.route(state.content));
                              },
                              child: Icon(Icons.play_arrow),
                              backgroundColor: kHeaderYelowColor,
                            );
                          if (state is ContentStates) {
                            return errorWidgetBuilder(state.content);
                          }
                          return SizedBox();
                        },
                      ),
                      slivers: [
                        SliverAppBar(
                          backgroundColor: kBackgroundColor,
                          expandedHeight: 200,
                          pinned: true,
                          flexibleSpace: FlexibleSpaceBar(
                            title: Text(
                              (state as ContentStates).content.title.length > 40
                                  ? (state as ContentStates)
                                          .content
                                          .title
                                          .substring(0, 37) +
                                      '...'
                                  : (state as ContentStates).content.title,
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            background: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          (state as ContentStates)
                                              .content
                                              .backgrounds
                                              .first),
                                    ),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5)),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                          colors: [
                                        Colors.black.withOpacity(0.9),
                                        Colors.black.withOpacity(0)
                                      ])),
                                )
                              ],
                            ),
                          ),
                        ),
                        if (state is ContentStates &&
                            state.content.type == 's' &&
                            (state.content.children?.length ?? 0) > 0)
                          SliverToBoxAdapter(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Flexible(
                                  child: SizedBox(
                                      height: 40,
                                      child: PageView.builder(
                                        onPageChanged: (index) {
                                          setState(() {
                                            selectedSeason = index;
                                          });
                                        },
                                        itemCount:
                                            state.content.children.length,
                                        controller: seasonsPageController,
                                        physics: ClampingScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          return ChildWidget(
                                              onTap: () {
                                                if (index != selectedSeason &&
                                                    index ==
                                                        seasonsPageController
                                                            .page
                                                            .toInt()) {
                                                  setState(() {
                                                    selectedSeason = index;
                                                  });
                                                  return;
                                                }

                                                seasonsPageController
                                                    .animateToPage(index,
                                                        duration: Duration(
                                                            milliseconds: 400),
                                                        curve: Curves.easeOut);
                                              },
                                              child:
                                                  state.content.children[index],
                                              isSelected:
                                                  index == selectedSeason);
                                        },
                                      )),
                                ),
                                if (selectedSeason != null &&
                                    (state.content.children[selectedSeason]
                                                .children?.length ??
                                            0) >
                                        0)
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: state.content
                                          .children[selectedSeason].children
                                          .map((e) => Flexible(
                                                  child: MovieWidget(
                                                movie: e,
                                                titleColor: kHeaderColor,
                                              )))
                                          .toList(),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        SliverPadding(
                          padding: EdgeInsets.all(0),
                          sliver: SliverList(
                            delegate: SliverChildListDelegate([
                              // Padding(
                              //   padding: EdgeInsets.only(left: 10, top: 20),
                              //   child: Row(
                              //     children: [
                              //       Text(
                              //         widget.movie.rating.toString(),
                              //         style: TextStyle(
                              //             color: Colors.white,
                              //             fontSize: 14,
                              //             fontWeight: FontWeight.bold),
                              //       ),
                              //       SizedBox(
                              //         width: 5,
                              //       ),
                              //       RatingBar(
                              //         itemSize: 8,
                              //         initialRating: widget.movie.rating / 2,
                              //         minRating: 1,
                              //         direction: Axis.horizontal,
                              //         allowHalfRating: true,
                              //         itemCount: 5,
                              //         itemPadding: EdgeInsets.symmetric(horizontal: 2),
                              //         itemBuilder: (context, index) => Icon(
                              //           EvaIcons.star,
                              //           color: Style.Colors.secondColor,
                              //         ),
                              //         onRatingUpdate: (value) {
                              //           print(value);
                              //         },
                              //       )
                              //     ],
                              //   ),
                              // ),

                              // if (snapshot.hasData &&
                              //     snapshot.data.videos.firstWhere(
                              //             (element) =>
                              //                 element.fileType == 'youtube',
                              //             orElse: () => null) !=
                              //         null)
                              //   Center(
                              //     child: SizedBox(
                              //       width: 150,
                              //       height: 70,
                              //       child: Padding(
                              //         padding: const EdgeInsets.all(8.0),
                              //         child: FlatButton(
                              //           shape: RoundedRectangleBorder(
                              //             borderRadius:
                              //                 BorderRadius.circular(16),
                              //           ),
                              //           color: Colors.red,
                              //           child: Text(
                              //             'Watch Trailer',
                              //             style:
                              //                 TextStyle(color: Colors.white),
                              //           ),
                              //           onPressed: () {
                              //             Navigator.of(context)
                              //                 .push(MaterialPageRoute(
                              //               builder: (context) =>
                              //                   YoutubePlayerPage(
                              //                 url: snapshot.data.videos
                              //                     .firstWhere(
                              //                         (element) =>
                              //                             element.fileType ==
                              //                             'youtube',
                              //                         orElse: () => null)
                              //                     .fileUrl,
                              //               ),
                              //             ));
                              //           },
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              Padding(
                                padding: EdgeInsets.only(left: 10, top: 20),
                                child: Text(
                                  'OVERVIEW',
                                  style: TextStyle(
                                      color: kTitleColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12),
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  (state as ContentStates).content.description,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              MovieInfo(
                                content: (state as ContentStates).content,
                              ),

                              Casts(
                                actors: (state as ContentStates).content.actors,
                              ),

                              // SimilarMovies(similarContents: ,
                              // )
                            ]),
                          ),
                        ),
                      ],
                    ),
                    builder: (context, event, child) {
                      return Positioned.fill(
                        child: child,
                        bottom: event == AdmobAdEvent.failedToLoad ||
                                event == AdmobAdEvent.closed
                            ? 0
                            : 50,
                      );
                    },
                  ),
                  if (setting.adsEnabled)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: AdmobBanner(
                        listener: (event, listener) {
                          admobEvemt.value = event;
                          print(event);
                        },
                        adUnitId: getBannerAdUnitId(),
                        adSize: AdmobBannerSize.BANNER,
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  FloatingActionButton errorWidgetBuilder(response.Content content) {
    return FloatingActionButton(
      elevation: 2,
      highlightElevation: 4,
      onPressed: () {
        setState(() {
          _cubit.updateContent(content);
        });
      },
      child: Icon(Icons.replay),
      backgroundColor: kHeaderYelowColor,
    );
  }

  Center loadingWidget() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(kYelowTitleColor),
      ),
    );
  }
}
