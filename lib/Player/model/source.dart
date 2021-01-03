import 'package:flutter/cupertino.dart';
import 'package:video_player/video_player.dart';

class Source {
  final String path;
  final DataSourceType type;
  Source({@required this.path, @required this.type})
      : assert(path != null),
        assert(type != null);
}
