import 'package:app/api/api.dart';
import 'package:app/screens/login.dart';
import 'package:flutter/material.dart';
import 'screens/home.dart';

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final apiInstance = API(
      baseURL: 'beta.myrunes.com', 
      prefix: 'api', 
      https: true
    );

    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(title: 'MYRUNES', apiInstance: apiInstance),
        '/login': (context) => LoginPage(),
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


