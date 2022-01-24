import 'package:bloc/bloc.dart';

class MainBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
  }

  @override
  void onCreate(BlocBase bloc) {
    // TODO: implement onCreate
    super.onCreate(bloc);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
  }
}
