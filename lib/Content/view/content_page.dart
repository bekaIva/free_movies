import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:free_movies/Api/TubiApi.dart';
import 'package:free_movies/Content/bloc/content_cubit.dart';
import 'package:free_movies/Content/view/content_form.dart';
import 'package:free_movies/home/model/home_response.dart' as response;

class ContentPage extends StatelessWidget {
  static Route route(response.Content content) => MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) =>
              ContentCubit(content, tubiApi: context.read<TubiApi>()),
          child: ContentPage(),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return ContentForm();
  }
}
