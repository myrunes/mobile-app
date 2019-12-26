import 'package:app/api/api.dart';
import 'package:app/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home.dart';
import 'models/login.dart';

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => LoginModel()),
        Provider(create: (context) => API(baseURL: 'https://beta.myrunes.com/api')),
      ],
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => HomePage(title: 'MYRUNES'),
          '/login': (context) => LoginPage(),
        },
        title: 'myrunes',
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.pink,
          accentColor: Colors.pink,
        ),
      )
    );
  }
}


