import 'package:equatable/equatable.dart';

class UserSetting extends Equatable {
  UserSetting({ this.showNotifications});
  final bool showNotifications;
  UserSetting.initial()
      : this.showNotifications = true;
  UserSetting.fromJson(Map<String, dynamic> json)
      : showNotifications = json == null ? null : json['showNotifications'];

  Map<String, dynamic> toJson() => {
    'showNotifications': showNotifications
  };

  @override
  List<Object> get props => [showNotifications];
}
