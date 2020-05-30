import 'package:flutter/material.dart';

import 'package:flutterapp1/maps/mapsgoogle.dart';
void main() {
  runApp(MyApp());
}
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'hello',
      home: Scaffold(
        appBar: AppBar(
          title: Text('hello'),
          backgroundColor: Colors.blueAccent,

        ),
body:PageMap() ,
      ),
    );
  }
}

