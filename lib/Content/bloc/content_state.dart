part of 'content_cubit.dart';

class ContentState extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

abstract class ContentStates extends ContentState {
  final Content content;
  ContentStates({@required this.content}) : assert(content != null);
}

class ContentInitial extends ContentStates {
  ContentInitial({Content content}) : super(content: content);
}

class ContentLoading extends ContentStates {
  ContentLoading(Content content) : super(content: content);
}

class ContentLoaded extends ContentStates {
  ContentLoaded(Content content) : super(content: content);
}

class ContentError extends ContentStates {
  final Exception exception;
  ContentError(Content content, {this.exception}) : super(content: content);
}

abstract class SeasonsStates extends ContentState {}
