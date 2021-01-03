import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:free_movies/constants/Constants.dart';
import 'package:free_movies/container/bloc/container_bloc.dart';
import 'package:free_movies/home/model/home_response.dart';
import 'package:free_movies/widgets/HorizontalMoviesList.dart';

class ContainerForm extends StatefulWidget {
  @override
  _ContainerFormState createState() => _ContainerFormState();
}

class _ContainerFormState extends State<ContainerForm> {
  ContainerBloc _bloc;
  @override
  void initState() {
    _bloc = context.read<ContainerBloc>();
    if (_bloc.state is EmptyState) _bloc.add(Load());
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(_bloc.container.title,),backgroundColor: kLigthBackgroundColor,),backgroundColor: kLigthBackgroundColor,
      body: BlocBuilder<ContainerBloc, ContainerState>(
        builder: (context, state) {
          return Stack(
            children: [
              if (state is StateLoaded)
                ContentsGridWidget(
                  state.contents,
                  scrollToEnd: () {
                    if (state is StateLoaded && state.isMoreAvailable) {
                      _bloc.add(LoadNext());
                    }
                  },
                ),
              if (state is StateLoading)
                Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(kYelowTitleColor),
                  ),
                )
            ],
          );
        },
      ),
    );
  }
}

class ContentsGridWidget extends StatefulWidget {
  final Function scrollStart;
  final Function scrolling;
  final Function scrollToEnd;
  final List<Content> contents;
  ContentsGridWidget(this.contents,
      {this.scrollStart, this.scrolling, this.scrollToEnd});
  @override
  _ContentsGridWidgetState createState() => _ContentsGridWidgetState();
}

class _ContentsGridWidgetState extends State<ContentsGridWidget> {
  ScrollController _controller;
  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(() {});
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: (notification) {
        if (notification is ScrollStartNotification) widget.scrollStart?.call();
        if (notification is ScrollUpdateNotification) widget.scrolling?.call();
        if (notification is OverscrollNotification) widget.scrollToEnd?.call();
      },
      child: GridView.builder(
        controller: _controller,
        itemCount: widget.contents.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, childAspectRatio: .5),
        itemBuilder: (context, index) {
          return MovieWidget(
            movie: widget.contents[index],
            titleColor: Colors.white,
          );
        },
      ),
    );
  }
}
