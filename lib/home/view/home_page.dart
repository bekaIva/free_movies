import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:free_movies/AllMoviesPage/AllMoviesPage.dart';
import 'package:free_movies/AllTvShowsPage/all_tv_shows_page.dart';
import 'package:free_movies/Api/TubiApi.dart';
import 'package:free_movies/GlobalSettings/global_settings_bloc.dart';
import 'package:free_movies/GlobalSettings/models/global_setting.dart';
import 'package:free_movies/constants/Constants.dart';
import 'package:free_movies/home/bloc/home_page_bloc.dart';
import 'package:free_movies/home/bloc/search_bloc/search_bloc.dart';
import 'package:free_movies/home/view/SearchDelegate.dart';
import 'package:free_movies/home/view/widgets/home_widget.dart';
import 'package:free_movies/main.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class HomePage extends StatefulWidget {
  static Route route() => MaterialPageRoute(
        builder: (_) => HomePage(),
      );

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final BannerAd myBanner = BannerAd(
    adUnitId: getBannerAdUnitId(),
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(),
  );
  int bottomNavigationIndex = 0;
  PageController _pageController = PageController(
    initialPage: 0,
  );
  HomePageBloc _bloc;

  @override
  void initState() {
    myBanner.load();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    myBanner.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalSettingsBloc, GlobalSetting>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            if (bottomNavigationIndex > 0) {
              _pageController.jumpToPage(
                bottomNavigationIndex - 1,
              );
              return false;
            } else {}
            return true;
          },
          child: Scaffold(
            backgroundColor: kLigthBackgroundColor,
            appBar: AppBar(
              backgroundColor: kLigthBackgroundColor,
              title: Text(
                indexToAppbarName(bottomNavigationIndex),
              ),
              actions: [
                IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      showSearch(
                        context: context,
                        delegate: HomeSearchDelegate(
                          context.read<SearchBloc>(),
                        ),
                      );
                    }),
              ],
            ),
            bottomNavigationBar: Theme(
              data: Theme.of(context)
                  .copyWith(canvasColor: kLigthBackgroundColor),
              child: BottomNavigationBar(
                showUnselectedLabels: true,
                selectedItemColor: kHeaderYelowColor,
                unselectedItemColor: kTitleColor,
                currentIndex: bottomNavigationIndex,
                onTap: (index) {
                  _pageController.jumpToPage(
                    index,
                  );
                },
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(EvaIcons.home), label: 'Home'),
                  BottomNavigationBarItem(
                      icon: Icon(FontAwesomeIcons.film), label: 'Movies'),
                  BottomNavigationBarItem(
                      icon: Icon(FontAwesomeIcons.theaterMasks),
                      label: 'TV Shows'),
                ],
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: PageView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (value) {
                      setState(() {
                        bottomNavigationIndex = value;
                      });
                    },
                    children: [
                      MultiBlocProvider(providers: [
                        BlocProvider(
                          create: (context) =>
                              HomePageBloc(context.read<TubiApi>()),
                        ),
                      ], child: HomeWidget()),
                      BlocProvider(
                        create: (context) =>
                            MoviesListBloc(context.read<TubiApi>()),
                        child: AllMoviesPage(),
                      ),
                      BlocProvider(
                        create: (context) =>
                            MoviesListBloc(context.read<TubiApi>()),
                        child: AllTvShowsPage(),
                      ),
                    ],
                  ),
                ),
                if (state.adsEnabled)
                  SizedBox(
                    height: myBanner.size.height.toDouble(),
                    width: myBanner.size.width.toDouble(),
                    child: AdWidget(
                      ad: myBanner,
                    ),
                  )
              ],
            ),
          ),
        );
      },
    );
  }

  String indexToAppbarName(int index) {
    switch (index) {
      case 0:
        return 'Home';
      case 1:
        return 'Movies';
      case 2:
        return 'TV Shows';
      default:
        return '';
    }
  }
}
