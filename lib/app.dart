import 'package:myrunes/api/api.dart';
import 'package:myrunes/screens/login.dart';
import 'package:flutter/material.dart';
import 'screens/home.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _apiInstance =
        API(baseURL: 'beta.myrunes.com', prefix: 'api', https: true);

    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(title: 'MYRUNES', apiInstance: _apiInstance),
        '/login': (context) => LoginPage(_apiInstance),
      },
      title: 'myrunes',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.pink,
        accentColor: Colors.pink,
      ),
    );
  }
}
