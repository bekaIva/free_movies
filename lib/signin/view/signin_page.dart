import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:free_movies/signin/cubit/signin_cubit.dart';
import 'package:free_movies/signin/view/signin_form.dart';

class SignInPage extends StatelessWidget {
  static Route route() => MaterialPageRoute(builder: (_) => SignInPage());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign in'),
      ),
      body: BlocProvider(
        create: (_) => SignInCubit(context.read<AuthenticationRepository>()),
        child: SigninForm(),
      ),
    );
  }
}
