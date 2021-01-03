import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:free_movies/Content/view/content_page.dart';
import 'package:free_movies/constants/Constants.dart';
import 'package:free_movies/home/model/home_response.dart' as response;

class MovieWidget extends StatefulWidget {
  final Color titleColor;
  final response.Content movie;
  MovieWidget({this.movie, this.titleColor});
  @override
  _MovieWidgetState createState() => _MovieWidgetState();
}

class _MovieWidgetState extends State<MovieWidget> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        //120 180
        double width =
            constraints.hasBoundedWidth ? constraints.maxWidth / 1.2 : 120;

        double height = width * 1.5;
        return Align(
          child: Column(mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Stack(
                  alignment: Alignment.center,
                  fit: StackFit.loose,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(fit: FlexFit.loose,
                            child: widget.movie.thumbnails?.first == null
                                ? Container(
                                    decoration: BoxDecoration(
                                        color: kYelowTitleColor,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(2),
                                        ),
                                        shape: BoxShape.rectangle),
                                    child: Column(
                                      children: [
                                        Icon(
                                          EvaIcons.filmOutline,
                                          color: Colors.white,
                                          size: 50,
                                        )
                                      ],
                                    ),
                                  )
                                : Container(
                                    width: width,
                                    height: height,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(2)),
                                      shape: BoxShape.rectangle,
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              widget.movie.thumbnails.first),
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: 100,
                            child: Text(
                              widget.movie.title,
                              maxLines: 2,
                              style: TextStyle(
                                  height: 1.4,
                                  color: widget.titleColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned.fill(
                      child: Material(
                        type: MaterialType.transparency,
                        child: RawMaterialButton(
                          onPressed: () {
                            Navigator.of(context)
                                .push(ContentPage.route(widget.movie));
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class HorizontalMoviesList extends StatelessWidget {
  final Function onMoreTap;
  final List<response.Content> movies;
  const HorizontalMoviesList({this.movies,this.onMoreTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          top: 40,
          child: ListView.builder(
            shrinkWrap: false,
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (context, index) => Padding(
              padding: EdgeInsets.only(top: 0, left: 10, right: 10),
              child: MovieWidget(
                movie: movies[index],
                titleColor: Colors.white,
              ),
            ),
          ),
        ),
        Positioned(
          child: TextButton(onPressed: onMoreTap,style: TextButton.styleFrom(primary: kTitleColor), child: Text('Load more')),
          right: 0,
          top: 0,
        ),
      ],
    );
  }
}
