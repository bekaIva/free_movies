import 'dart:math';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:free_movies/Player/bloc/player_bloc.dart' as bloc;
import 'package:free_movies/Player/model/exceptions.dart';
import 'package:free_movies/Player/model/source.dart';
import 'package:free_movies/constants/Constants.dart';
import 'package:free_movies/home/model/home_response.dart' as response;
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

class PlayerPage extends StatefulWidget {
  final response.Content content;
  PlayerPage({this.content});
  static Route route(response.Content content) => MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => bloc.PlayerBloc(),
          child: PlayerPage(
            content: content,
          ),
        ),
      );

  @override
  _PlayerPageState createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  int lastInteraction;
  bool showControls = false;
  VideoPlayerController controller;
  bool isFullscreen = false;
  bloc.PlayerBloc playerBloc;
  @override
  void initState() {
    playerBloc = context.read<bloc.PlayerBloc>();
    playerBloc.add(bloc.LoadSource(
        source:
            Source(type: DataSourceType.network, path: widget.content.url)));
    // controller = VideoPlayerController.network(
    //   widget.content.url,
    // );

    // controller.initialize().whenComplete(() => controller.play());
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    if (isFullscreen) toggleFullscreen();
    super.dispose();
  }

  void showControllers() {
    lastInteraction = DateTime.now().millisecondsSinceEpoch;
    hideControllers(false);
    if (showControls) return;
    setState(() {
      showControls = true;
    });
  }

  void hideControllers(bool instant) async {
    await Future.delayed(Duration(milliseconds: 4500));
    if (lastInteraction + 4500 < DateTime.now().millisecondsSinceEpoch &&
        mounted &&
        showControls) {
      setState(() {
        showControls = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.black,
      body: OrientationBuilder(
        builder: (context, orientation) {
          var screenOrient = orientation == Orientation.landscape;
          isFullscreen = screenOrient;
          SystemChrome.setEnabledSystemUIOverlays(isFullscreen
              ? []
              : [
                  SystemUiOverlay.top,
                  SystemUiOverlay.bottom,
                ]);
          return Center(
            child: AspectRatio(
              aspectRatio:
                  isFullscreen ? MediaQuery.of(context).size.aspectRatio : 16 / 9,
              child: GestureDetector(
                onTap: () {
                  showControllers();
                },
                child: Stack(
                  children: [
                    Positioned.fill(
                        child: BlocBuilder<bloc.PlayerBloc, bloc.State>(
                      builder: (context, state) {
                        if (state is bloc.SourceLoaded) {
                          return VideoPlayer(state.controller);
                        }
                        if (state is bloc.SourceLoading) {
                          return Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation(kHeaderYelowColor),
                            ),
                          );
                        }
                        if (state is bloc.ExceptionOccoured) {
                          return Material(
                            type: MaterialType.transparency,
                            child: Center(
                              child: IconButton(
                                icon: Icon(
                                  Icons.refresh,
                                ),
                                color: Colors.grey,
                                iconSize: 50,
                                onPressed: () {
                                  context.read<bloc.PlayerBloc>().add(
                                      bloc.LoadSource(
                                          source: Source(
                                              type: DataSourceType.network,
                                              path: widget.content.url)));
                                },
                              ),
                            ),
                          );
                        }
                        return Center(
                          child: Text('Nothing to shiow'),
                        );
                      },
                      buildWhen: (previous, current) {
                        if (current is bloc.InitialState ||
                            current is bloc.SourceLoading ||
                            current is bloc.SourceLoaded ||
                            current is SourceLoadFailed ||
                            current is bloc.ExceptionOccoured)
                          return true;
                        else
                          return false;
                      },
                    )),
                    Positioned.fill(
                        child: AbsorbPointer(
                      child: AnimatedOpacity(
                        opacity: showControls ? 1 : 0,
                        duration: Duration(milliseconds: 400),
                        child: PlayerControls(
                          isFullscreen: isFullscreen,
                          onInteraction: () {
                            showControllers();
                          },
                          onFullscreen: () {
                            hideControllers(false);
                            toggleFullscreen();
                          },
                        ),
                      ),
                      absorbing: !showControls,
                    ))
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> toggleFullscreen() async {
    SystemChrome.setPreferredOrientations(!isFullscreen
        ? [
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ]
        : [DeviceOrientation.portraitUp]);
  }
}

class PlayerControls extends StatefulWidget {
  final bool isFullscreen;
  final Function onFullscreen;
  final Function onInteraction;

  PlayerControls({this.isFullscreen, this.onFullscreen, this.onInteraction});
  @override
  _PlayerControlsState createState() => _PlayerControlsState();
}

class _PlayerControlsState extends State<PlayerControls>
    with TickerProviderStateMixin {
  Animation<double> playPauseAnimation;
  AnimationController playPauseController;

  Animation<double> fullscreenOfFullscreenAnimation;
  AnimationController fullscreenOfFullscreenController;

  @override
  void initState() {
    fullscreenOfFullscreenController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    fullscreenOfFullscreenAnimation = Tween<double>(begin: 0, end: 1)
        .animate(fullscreenOfFullscreenController);

    playPauseController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    playPauseAnimation =
        Tween<double>(begin: 0, end: 1).animate(playPauseController);
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    fullscreenOfFullscreenController.dispose();
    playPauseController.dispose();
    // TODO: implement dispose
    super.dispose();
    Wakelock.disable();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isFullscreen && fullscreenOfFullscreenController.value == 0)
      fullscreenOfFullscreenController.forward();
    if (!widget.isFullscreen && fullscreenOfFullscreenController.value == 1)
      fullscreenOfFullscreenController.reverse();
    return BlocBuilder<bloc.PlayerBloc, bloc.State>(
      buildWhen: (previous, current) => current is bloc.ControllerValueChanged,
      builder: (context, valueState) {
        if (valueState is bloc.ControllerValueChanged) {
          var controllerValue = valueState as bloc.ControllerValueChanged;
          var value = controllerValue.videoPlayerValue;
          if (value.isPlaying && playPauseController.value != 1) {

            playPauseController.forward();
            Wakelock.enable();
          }
          if (!value.isPlaying && playPauseController.value != 0) {
            playPauseController.reverse();
            Wakelock.disable();

          }

          return Stack(
            children: [
              if (value.isBuffering)
                Positioned(
                    top: 0,
                    right: 0,
                    bottom: 0,
                    left: 0,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(kYelowTitleColor),
                    )),
              Positioned(
                child: Container(padding: EdgeInsets.only(top: 8),
                 color: Colors.black.withOpacity(0.8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Material(
                        type: MaterialType.transparency,
                        child: IconButton(
                            icon: AnimatedIcon(
                              icon: AnimatedIcons.play_pause,
                              progress: playPauseAnimation,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              widget.onInteraction?.call();
                              if (value.isPlaying) {
                                controllerValue.controller.pause();
                              } else {
                                controllerValue.controller.play();
                              }
                            }),
                      ),
                      if (value.duration != null)
                        Expanded(
                          child: Material(
                              type: MaterialType.transparency,
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 22),
                                    child: Text(value.position.toString().split('.').first.padLeft(8, "0"),style: TextStyle(color: Colors.white),),
                                  ),
                                  Stack(
                                    children: [
                                      ...value.buffered
                                          .map((e) => SliderTheme(
                                                data: SliderThemeData(
                                                    disabledThumbColor:
                                                        Colors.transparent,
                                                    rangeThumbShape: MyShape(),
                                                    activeTrackColor: Colors.grey,
                                                    inactiveTrackColor:
                                                        Colors.transparent),
                                                child: RangeSlider(
                                                    values: RangeValues(
                                                        e.start.inSeconds /
                                                            value.duration.inSeconds,
                                                        e.end.inSeconds /
                                                            value.duration.inSeconds),
                                                    onChanged: (val) {}),
                                              ))
                                          .toList(),
                                      SliderTheme(
                                        data: SliderTheme.of(context).copyWith(
                                            inactiveTrackColor: Colors.transparent,
                                            activeTrackColor: kHeaderYelowColor,
                                            thumbColor: kYelowTitleColor),
                                        child: Slider(
                                            value: value.position.inSeconds /
                                                value.duration.inSeconds,
                                            onChangeStart: (val) {
                                              controllerValue.controller.pause();
                                            },
                                            onChangeEnd: (value) {
                                              controllerValue.controller.play();
                                            },
                                            onChanged: (val) {
                                              widget.onInteraction?.call();
                                              controllerValue.controller.seekTo(
                                                  Duration(
                                                      seconds: (val *
                                                              value
                                                                  .duration.inSeconds)
                                                          .toInt()));
                                              print(val);
                                            }),
                                      )
                                    ],
                                  ),
                                ],
                              )),
                        ),
                      if (widget.onFullscreen != null)
                        Material(
                          type: MaterialType.transparency,
                          child: IconButton(
                              icon: MyAnimatedIcon(
                                animation: fullscreenOfFullscreenAnimation,
                                forwardStateIcon: Icons.fullscreen_exit,
                                reverseStateIcon: Icons.fullscreen,
                              ),
                              onPressed: () {
                                widget.onInteraction?.call();
                                if (widget.isFullscreen) {
                                  widget.onFullscreen?.call();
                                } else {
                                  widget.onFullscreen?.call();
                                }
                              }),
                        ),
                    ],
                  ),
                ),
                bottom: 0,
                right: 0,
                left: 0,
              ),
            ],
          );
        }
        return Container();
      },
    );
  }
}

class MyAnimatedIcon extends StatefulWidget {
  final IconData forwardStateIcon;
  final IconData reverseStateIcon;
  final Animation<double> animation;

  MyAnimatedIcon(
      {this.forwardStateIcon, this.reverseStateIcon, this.animation});
  @override
  _MyAnimatedIconState createState() => _MyAnimatedIconState();
}

class _MyAnimatedIconState extends State<MyAnimatedIcon> {
  @override
  void initState() {
    widget.animation.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (widget.animation.value > 0)
          Opacity(
            opacity: widget.animation.value,
            child: Transform.rotate(
              child: Icon(
                widget.forwardStateIcon,
                color: Colors.white,
              ),
              angle: lerpDouble(-90 * pi / 180, 0, widget.animation.value),
            ),
          ),
        if (widget.animation.value < 1)
          Opacity(
            opacity: lerpDouble(1, 0, widget.animation.value),
            child: Transform.rotate(
              child: Icon(
                widget.reverseStateIcon,
                color: Colors.white,
              ),
              angle: widget.animation.value * pi / 2,
            ),
          ),
      ],
    );
  }
}

class MyShape extends RangeSliderThumbShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    // TODO: implement getPreferredSize
    return Size(.1, .1);
  }

  @override
  void paint(PaintingContext context, Offset center,
      {Animation<double> activationAnimation,
      Animation<double> enableAnimation,
      bool isDiscrete,
      bool isEnabled,
      bool isOnTop,
      TextDirection textDirection,
      SliderThemeData sliderTheme,
      Thumb thumb,
      bool isPressed}) {
    // TODO: implement paint
  }
}
