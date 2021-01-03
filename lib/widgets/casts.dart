import 'package:flutter/material.dart';
import 'package:free_movies/constants/Constants.dart';

class Casts extends StatefulWidget {
  List<String> actors;
  Casts({this.actors});
  @override
  _CastsState createState() => _CastsState();
}

class _CastsState extends State<Casts> {
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
            'CASTS',
            style: TextStyle(
                color: kTitleColor, fontWeight: FontWeight.w500, fontSize: 12),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          height: 140,
          padding: EdgeInsets.only(left: 10),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.actors.length,
            itemBuilder: (context, index) => Container(
              padding: EdgeInsets.only(top: 10, right: 8),
              width: 100,
              child: GestureDetector(
                onTap: () {},
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Container(
                    //   width: 70,
                    //   height: 70,
                    //   decoration: BoxDecoration(
                    //       shape: BoxShape.circle,
                    //       image: DecorationImage(
                    //         fit: BoxFit.cover,
                    //         image: NetworkImage(
                    //             widget.actors[index]),
                    //       )),
                    // ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.actors[index],
                      maxLines: 2,
                      style: TextStyle(
                          height: 1.4,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 9),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
