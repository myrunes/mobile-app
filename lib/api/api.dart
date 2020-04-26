import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import 'forms.dart';
import 'models.dart';

typedef T TransformFunction<T>(dynamic);

const SECURE_STORAGE_TOKEN_KEY = 'myrunes_api_token';
const COOKIE_TOKEN_KEY = 'jwt_token=';

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
  API({this.baseURL, this.prefix, this.https});

  final bool https;
  final String baseURL, prefix;

  ListResponse<Champion> champions;
  RunesInfoModel runes;

  final _storage = FlutterSecureStorage();

  Future<String> _getToken() {
    return _storage.read(key: SECURE_STORAGE_TOKEN_KEY);
  }

  Future _setToken(String token) {
    if (token == null) {
      return _storage.delete(key: SECURE_STORAGE_TOKEN_KEY);
    }
    return _storage.write(key: SECURE_STORAGE_TOKEN_KEY, value: token);
  }

  Future<Map<String, String>> _getHeaders() async {
    final m = <String, String>{
      'content-type': 'application/json',
    };

    final token = await _getToken();
    if (token != null && !m.containsKey('cookie')) {
      m['cookie'] = '$token;';
    }

    return m;
  }

  Uri _getUri(String path, [Map<String, dynamic> query]) {
    if (prefix != null) path = '$prefix/$path';

    return https
        ? Uri.https(baseURL, path, query)
        : Uri.http(baseURL, path, query);
  }

  Future<Response> _post(String path,
      {Mapable body, Map<String, dynamic> query}) async {
    var res = await http.post(_getUri(path, query),
        headers: await _getHeaders(),
        body: body != null ? json.encode(body.toMap()) : null,
        encoding: Encoding.getByName('application/json'));

    if (res.statusCode >= 400) {
      throw APIError(res);
    }

    return res;
  }

  Future<Response> _get(String path, [Map<String, dynamic> query]) async {
    var res = await http.get(
      _getUri(path, query),
      headers: await _getHeaders(),
    );

    if (res.statusCode >= 400) {
      throw APIError(res);
    }

    return res;
  }

  Future login(LoginFormModel m) async {
    final res = await _post('/login', body: m);
    final cookieHeader = res.headers['set-cookie'];
    final tokenStart = cookieHeader.indexOf(COOKIE_TOKEN_KEY);
    final tokenEnd = cookieHeader.indexOf(';', tokenStart);
    final token = cookieHeader.substring(tokenStart, tokenEnd);

    await _setToken(token);
  }

  Future logout() async {
    await _post('/logout');
    _setToken(null);
  }

  Future<UserModel> getMe() async {
    final res = await _get('/users/me');
    return UserModel.fromJson(json.decode(res.body));
  }

  Future<ListResponse<PageModel>> getPages() async {
    final res = await _get('/pages');
    final data = json.decode(res.body);
    return _getList(data, (e) => PageModel.fromJson(e));
  }

  Future<void> fetchChampions() async {
    final res = await _get('/resources/champions');
    final data = json.decode(res.body);
    champions = _getList(data, (e) => Champion.fromJson(e));
  }

  Future<void> fetchRunesInfo() async {
    final res = await _get('/resources/runes');
    final data = json.decode(res.body);
    runes = RunesInfoModel.fromJson(data);
  }
}

ListResponse<T> _getList<T>(Map<String, dynamic> data, TransformFunction tf) {
  final n = data['n'] ?? 0;
  List<T> d = [];
  if (data['data'] != null) {
    d = (data['data'] as List).map<T>((e) => tf(e)).toList();
  }
  return ListResponse(n: n, data: d);
}
