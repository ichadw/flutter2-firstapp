import 'package:flutter/material.dart';
import 'home.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

Future main() async {
  await DotEnv.load(fileName: ".env");
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
