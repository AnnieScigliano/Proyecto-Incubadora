import 'package:incubapp_lite/models/wifi_model.dart';
import 'package:incubapp_lite/views/initial_home.dart';
import 'package:incubapp_lite/services/api_services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WHome extends StatefulWidget {
  const WHome({Key? key}) : super(key: key);

  @override
  _WHomeState createState() => _WHomeState();
}

class _WHomeState extends State<WHome> {
  late Wifi? _wifiModel = null;
  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    _wifiModel = (await ApiService().getWifi());
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('REDES DIPONIBLES'),
      ),
      body: _wifiModel == null
      ? const Center(
          child: CircularProgressIndicator(),
        )
      : ListView.builder(
          itemCount: _wifiModel!.networks.length, // Utiliza la longitud de la lista de redes
          itemBuilder: (context, index) {
            final network = _wifiModel!.networks[index]; // Obtén la red en la posición actual
            return Card(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('SSID:'),
                      Text(network.ssid),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('RSSI:'),
                      Text(network.rssi.toString()),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            );
          },
        ),

      );
  }
}