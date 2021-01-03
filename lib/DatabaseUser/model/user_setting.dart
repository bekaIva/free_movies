import 'package:equatable/equatable.dart';

class UserSetting extends Equatable {
  final bool showNotifications;
  UserSetting.fromJson(Map<String, dynamic> json)
      : showNotifications = json == null ? null : json['showNotifications'];

  @override
  List<Object> get props => [showNotifications];
}
