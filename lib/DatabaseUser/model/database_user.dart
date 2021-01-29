import 'package:authentication_repository/authentication_repository.dart';
import 'package:free_movies/DatabaseUser/model/user_setting.dart';

class DatabaseUser extends User {
  final UserSetting userSetting;
  DatabaseUser(
      {this.userSetting, String email, String id, String name, String photo})
      : super(photo: photo, name: name, id: id, email: email);
  DatabaseUser.fromJson(Map<String, dynamic> json)
      : userSetting = UserSetting.fromJson(json['userSetting']),
        super.fromJson(json);
  DatabaseUser.fromUser(User user)
      : userSetting = UserSetting.initial(),
        super(
          email: user.email, id: user.id, name: user.name, photo: user.photo);

  Map<String, dynamic> toJson() =>
      {...?super.toJson(), 'userSetting': userSetting?.toJson()};

  DatabaseUser copyWith(
      {UserSetting userSetting,
        String email,
        String id,
        String name,
        String photo}) =>
      DatabaseUser(
          userSetting: userSetting ?? this.userSetting,
          email: email ?? this.email,
          id: id ?? this.id,
          name: name ?? this.name);

  @override
  List<Object> get props => [...super.props, userSetting];
}
