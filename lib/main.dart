import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:unsplash_bloc/src/views/home/HomeUI.dart';
import 'package:unsplash_bloc/src/views/photo/PhotoUI.dart';
import 'package:unsplash_bloc/src/views/profile/ProfileUI.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Unsplash Flutter',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Color(0xff17223b),
          brightness: Brightness.dark,
          cupertinoOverrideTheme: CupertinoThemeData(
            brightness: Brightness.dark,
            primaryColor: Color(0xff17223b),
          )),
      home: HomeUI(),
    );
  }
}
