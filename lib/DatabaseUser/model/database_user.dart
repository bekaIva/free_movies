import 'package:authentication_repository/authentication_repository.dart';
import 'package:free_movies/DatabaseUser/model/user_setting.dart';

class DatabaseUser extends User {
  final UserSetting userSetting;
  DatabaseUser.fromJson(Map<String, dynamic> json)
      : userSetting = UserSetting.fromJson(json['userSetting']),
        super.fromJson(json);
  @override
  List<Object> get props => [...super.props, userSetting];
}
