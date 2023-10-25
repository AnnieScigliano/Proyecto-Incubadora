import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:incubapp_lite/models/max_temp_model.dart';
import 'package:incubapp_lite/views/home.dart';
import 'package:incubapp_lite/views/wifi_home.dart';
import 'package:incubapp_lite/services/api_services.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: IHome(),
    ));

@override
class IHome extends StatefulWidget {
  @override
  _IHomeState createState() => _IHomeState();
}

late Maxtemp? _maxModel = Maxtemp(message: "", maxtemp: 0);

class _IHomeState extends State<IHome> {
  @override
  Widget build(BuildContext context) {
    // double maxTemp = 39;
    // double maxTemp = 28;
    double maxTemp = 37.5;

    double humidity = 60;
    // double humidity = 30;
    //double humidity = 90;

    Size size = MediaQuery.of(context).size; // píxeles lógicos

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(children: [
        Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.blueAccent, Colors.blue])),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                FontAwesomeIcons.temperatureHalf,
                color: Colors.white,
                size: 40.0,
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              temperatureTitle(size),
              const SizedBox(
                height: 30.0,
              ),
              temperatureValue(size, maxTemp),
              const SizedBox(
                height: 30.0,
              ),
              const Icon(
                FontAwesomeIcons.droplet,
                color: Colors.white,
                size: 40.0,
              ),
              const SizedBox(
                height: 10.0,
              ),
              humidityTitle(size),
              SizedBox(
                height: size.height * 0.05,
              ),
              humidityValue(size, humidity),
            ],
          )),
        ),
        Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              children: [
                FloatingActionButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Home()));
                    },
                    child: const Icon(FontAwesomeIcons.gear)),
                FloatingActionButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => WifiHome()));
                    },
                    child: const Icon(FontAwesomeIcons.wifi)),
              ],
            )),
      ]),
    );
  }
}

Widget temperatureTitle(size) {
  return Text("Temperatura:",
      style: GoogleFonts.questrial(
          color: Colors.white, fontSize: size.height * 0.05));
}

Widget temperatureValue(size, maxTemp) {
  return Text(
    '$maxTemp˚C', //max temperature
    style: GoogleFonts.questrial(
      color: Tcolor(maxTemp),
      fontSize: size.height * 0.13,
    ),
  );
}

Color Tcolor(maxTemp) {
  if (maxTemp <= 0) {
    return Colors.yellow; // -= 0: Verde
  } else if (maxTemp <= 38 && maxTemp >= 36.5) {
    return Colors.lightGreenAccent; // -= 37.5: Verde
  } else {
    return Colors.red; // > 37.5: Rojo
  }
}

Color Hcolor(humidity) {
  if (humidity <= 0) {
    return Colors.red; // -= 0: Verde
  } else if (humidity <= 70.0 && humidity >= 55.0) {
    return Colors.lightGreenAccent; // -= 37.5: Verde
  } else {
    return Colors.red; // > 37.5: Rojo
  }
}

Widget humidityTitle(size) {
  return Text("Humedad:",
      style: GoogleFonts.questrial(
          color: Colors.white, fontSize: size.height * 0.05));
}

Widget humidityValue(size, humidity) {
  return Text(
    '$humidity %', //max temperature
    style: GoogleFonts.questrial(
      color: Hcolor(humidity),
      fontSize: size.height * 0.13,
    ),
  );
}
