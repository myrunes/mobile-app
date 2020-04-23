import 'models.dart';

class LoginFormModel implements Mapable {
  LoginFormModel({this.username, this.password, this.remember});

  String username;
  String password;
  bool remember;

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'password': password,
      'remember': remember,
    };
  }
}
