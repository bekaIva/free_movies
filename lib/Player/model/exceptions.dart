import 'package:free_movies/Player/model/source.dart';

class SourceLoadFailed implements Exception {
  final String message;
  final Source source;
  SourceLoadFailed({this.source, this.message});
}
