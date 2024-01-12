import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:incubapp_lite/models/actual_model.dart';
//import 'package:incubapp_lite/views/home.dart';
//import 'package:incubapp_lite/views/login.dart';
//import 'package:incubapp_lite/views/wifi_home.dart';
//import 'package:incubapp_lite/services/api_services.dart';
//import 'package:incubapp_lite/services/counter_home.dart';
//import 'package:incubapp_lite/services/graf_home.dart';

class CHome extends StatefulWidget {
  @override
  _CHomeState createState() => _CHomeState();
}

class _CHomeState extends State<CHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contador de Días'),
      ),
      body: Center(
        child: Text(
          'mimimi',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}