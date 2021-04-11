import 'package:flutter/material.dart';
import 'home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Music Player App',
      theme: new ThemeData(
        primaryColor: Colors.blue,
        primaryColorBrightness: Brightness.dark,
      ),
      home: new Homepage(),
    );
  }
}
