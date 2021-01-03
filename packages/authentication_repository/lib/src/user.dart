import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String email;
  final String id;
  final String name;
  final String photo;
  const User({this.email, this.id, this.name, this.photo});
  Map<String, dynamic> toJson() =>
      {'email': email, 'id': id, 'name': name, 'photo': photo};
  User.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        id = json['id'],
        name = json['name'],
        photo = json['photo'];

  static const empty = User(name: '', id: '', email: '', photo: null);

  @override
  // TODO: implement props
  List<Object> get props => [email, id, name, photo];
}
