import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:free_movies/Content/content.dart';
import 'package:free_movies/GlobalSettings/global_settings_bloc.dart';
import 'package:free_movies/blocs/interstitialBloc.dart';
import 'package:free_movies/constants/Constants.dart';
import 'package:free_movies/home/model/home_response.dart' as resopnse;
import 'package:page_indicator/page_indicator.dart';
import 'package:provider/provider.dart';

class SliderMovies extends StatefulWidget {
  resopnse.HomeResponse response;
  SliderMovies({this.response});
  @override
  _SliderMoviesState createState() => _SliderMoviesState();
}

class _SliderMoviesState extends State<SliderMovies> {
  List<resopnse.Content> contents;
  resopnse.Container container;
  @override
  void initState() {
    container = widget.response.containers
        .firstWhere((element) => element.id == 'featured');
    contents =
        container.children.map((e) => widget.response.contents[e]).toList();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PageIndicatorContainer(
        align: IndicatorAlign.bottom,
        shape: IndicatorShape.circle(size: 5),
        indicatorSpace: 8,
        padding: EdgeInsets.all(5),
        indicatorColor: kYelowTitleColor,
        indicatorSelectorColor: kHeaderYelowColor,
        child: PageView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: contents.length,
          itemBuilder: (context, index) => Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 220,
                decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(contents[index].posterarts.first))),
              ),
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: [0, 0.8],
                  colors: [
                    kBackgroundColor.withOpacity(1),
                    kBackgroundColor.withOpacity(0),
                  ],
                )),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: Material(
                  type: MaterialType.transparency,
                  child: Center(
                    child: IconButton(
                      color: kYelowTitleColor,
                      splashRadius: 30,
                      iconSize: 40,
                      onPressed: () {
                        if (context
                            .read<GlobalSettingsBloc>()
                            .state
                            .adsEnabled) {
                          if (context.read<InterstitialBloc>().state
                              is AdLoaded) {
                            context.read<InterstitialBloc>().showAd();
                          }

                          //todo show interstitial
                        }
                        Navigator.of(context)
                            .push(ContentPage.route(contents[index]));
                      },
                      icon: Icon(
                        FontAwesomeIcons.playCircle,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 30,
                child: Container(
                  padding: EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  width: 250,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contents[index].title,
                        style: TextStyle(
                            height: 1.5,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        length: contents.length,
      ),
      height: 220,
    );
  }
}
