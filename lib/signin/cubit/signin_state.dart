part of 'signin_cubit.dart';

class SignInState {
  final Email email;
  final Password password;
  final FormzStatus status;

  SignInState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.status = FormzStatus.pure,
  });

  SignInState copyWith({
    Email email,
    Password password,
    FormzStatus status,
  }) {
    return SignInState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
    );
  }
}
