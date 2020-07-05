import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kmlameals/view/meal.dart';
import 'dart:async';
import 'package:kmlameals/resource/firebasefumc.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var now = new DateTime.now();
    var date = now.day;
    String day = date.toString();

    return new MaterialApp(
        title: 'Minjok Herald',
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: new SplashScreen(),
        routes: <String, WidgetBuilder>{
          '/HomeScreen': (BuildContext context) => new Mealview(day:day)});

//        home: new RootPage(auth: new Auth()));
  }


}
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => new _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var _duration = new Duration(seconds: 1);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/HomeScreen');
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      body: new Center(
          child: new Container(
            padding: EdgeInsets.all(80),
            child: new Image.asset('assets/logo2-purple.png'),
          )

      ),
    );
  }
}