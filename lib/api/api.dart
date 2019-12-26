import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import 'models.dart';

const SECURE_STORAGE_TOKEN_KEY = 'myrunes_api_token';

class APIError {
  String reason;
  int statusCode;
  Response res;

  APIError(this.res) {
    if (res.body != null && res.body.length > 0) {
      final err = ErrorResponse.fromJson(json.decode(res.body));
      reason = err.message;
    }
    statusCode = res.statusCode;
  }
}

class API {
  final String baseURL;
  final _storage = FlutterSecureStorage();

  API({this.baseURL});

  Future<String> _getToken() {
    return _storage.read(key: SECURE_STORAGE_TOKEN_KEY);
  }

  Future _setToken(String token) {
    return _storage.write(key: SECURE_STORAGE_TOKEN_KEY, value: token);
  }

  Future<Response> _post(String path, Mappable body) async {
    var res = await http.post(
      '$baseURL$path', 
      body: json.encode(body.toMap()), 
      encoding: Encoding.getByName('application/json')
    );

    if (res.statusCode >= 400) {
      throw APIError(res);
    }

    return res;
  }

  Future login(LoginFormModel m) async {
    const COOKIE_TOKEN_KEY = '__session=';

    final res = await _post('/login', m);
    final cookieHeader = res.headers['set-cookie'];
    final tokenStart = cookieHeader.indexOf(COOKIE_TOKEN_KEY) + COOKIE_TOKEN_KEY.length;
    final tokenEnd = cookieHeader.indexOf(';', tokenStart);
    final token = cookieHeader.substring(tokenStart, tokenEnd);

    await _setToken(token);
  }
}