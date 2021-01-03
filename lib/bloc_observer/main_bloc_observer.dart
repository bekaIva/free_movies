import 'package:bloc/bloc.dart';

class MainBlocObserver extends BlocObserver {
  @override
  void onCreate(Cubit cubit) {}

  @override
  void onClose(Cubit cubit) {}

  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace) {}

  @override
  void onTransition(Bloc bloc, Transition transition) {}

  @override
  void onChange(Cubit cubit, Change change) {}

  @override
  void onEvent(Bloc bloc, Object event) {}
}
