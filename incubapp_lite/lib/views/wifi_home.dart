import 'package:incubapp_lite/models/wifi_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:incubapp_lite/views/initial_home.dart';
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
      body: _maxModel == null || _minModel == null || _verModel == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return Card(
                  child: Column(
                    child: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('SSID List:'),
                          Text(_wifiModel!.wifi.toString()),
                          Text(_wifiModel!.message),
                        ],
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}