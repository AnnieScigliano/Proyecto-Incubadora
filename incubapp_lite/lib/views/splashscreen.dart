import 'package:flutter/material.dart';
import 'package:incubapp_lite/views/initial_home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(
      Duration(seconds: 5), 
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => IHome()),
        );
      },
    );

    return Scaffold(
      body: Center(
        child: LogoWidget(),
      ),
    );
  }
}

class LogoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/logo.png', width: 300, height: 300);
  }
}