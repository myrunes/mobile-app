abstract class Mappable {
  Map<String, dynamic> toMap();
}

class LoginFormModel implements Mappable {
  String username;
  String password;

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic> {
      'username': username,
      'password': password,
    };
  }
}

class ErrorResponse {
  final String message;
  final int code;

  ErrorResponse.fromJson(Map<String, dynamic> json) 
    : message = json['message'], 
      code = json['code'];
}