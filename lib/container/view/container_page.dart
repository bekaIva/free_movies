import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:free_movies/Api/TubiApi.dart';
import 'package:free_movies/container/bloc/container_bloc.dart';
import 'package:free_movies/container/container.dart';
import 'package:free_movies/home/model/home_response.dart' as homeResponse;

class ContainerPage extends StatelessWidget {
  static Route route(homeResponse.Container container) {
    return MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (context) => ContainerBloc(context.read<TubiApi>(), container),child: ContainerPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ContainerForm();
  }
}
