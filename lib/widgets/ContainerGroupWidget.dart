import 'package:flutter/material.dart';
import 'package:free_movies/constants/Constants.dart';
import 'package:free_movies/container/view/container_page.dart';
import 'package:free_movies/home/model/home_response.dart' as resopnse;

import 'HorizontalMoviesList.dart';


class ContainerGroupWidget extends StatefulWidget {
  final Map<resopnse.Container, List<resopnse.Content>> containers;
  ContainerGroupWidget({this.containers});
  @override
  _ContainerGroupWidgetState createState() => _ContainerGroupWidgetState();
}

class _ContainerGroupWidgetState extends State<ContainerGroupWidget>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    _tabController =
        TabController(length: widget.containers.length, vsync: this);
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 330,
      child: DefaultTabController(
        length: widget.containers.length,
        child: Scaffold(
          backgroundColor: kBackgroundColor,
          appBar: PreferredSize(
            child: AppBar(
              backgroundColor: kBackgroundColor,
              bottom: PreferredSize(child: Container(width: double.infinity,child: TabBar(
                indicatorColor: kHeaderYelowColor,
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorWeight: 3,
                unselectedLabelColor: kTitleColor,
                labelColor: Colors.white,
                isScrollable: true,
                tabs: widget.containers.entries
                    .map(
                      (container) => Container(
                    padding: EdgeInsets.only(bottom: 15, top: 10),
                    child: Text(
                      container.key.title,
                      style: TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
                    .toList(),
              ),))
            ),
            preferredSize: Size.fromHeight(50),
          ),
          body: TabBarView(
            controller: _tabController,
            physics: NeverScrollableScrollPhysics(),
            children: widget.containers.entries
                .map((e) => HorizontalMoviesList(
              onMoreTap: () {
                Navigator.of(context).push(ContainerPage.route(e.key));
              },
              movies: e.value,
            ))
                .toList(),
          ),
        ),
      ),
    );
  }
}