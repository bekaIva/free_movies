import 'package:flutter/cupertino.dart';
import 'package:formz/formz.dart';

enum ConfirmPasswordValidatorResult { invalid }

class ConfirmedPassword
    extends FormzInput<String, ConfirmPasswordValidatorResult> {
  final String password;
  const ConfirmedPassword.pure({this.password = ''}) : super.pure('');
  const ConfirmedPassword.dirty({@required this.password, String value})
      : super.dirty(value);

  @override
  ConfirmPasswordValidatorResult validator(String value) {
    // TODO: implement validator
    return password == value ? null : ConfirmPasswordValidatorResult.invalid;
  }
}
