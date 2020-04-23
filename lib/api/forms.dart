import 'models.dart';

class LoginFormModel implements Mapable {
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
