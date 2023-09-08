//import 'package:app/model/iss_position_model.dart';
import 'package:incubapp_lite/models/max_temp_model.dart';
import 'package:incubapp_lite/models/min_temp_model.dart';
import 'package:incubapp_lite/models/version_model.dart';
import 'package:incubapp_lite/models/rotation_model.dart';
import 'package:incubapp_lite/services/api_services.dart';

import 'package:flutter/material.dart';
//import 'package:app/model/user_model.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Maxtemp? _maxModel = null;
  late Mintemp? _minModel = null;
  late Version? _verModel = null;
<<<<<<< HEAD
  late Rotation? _rotModel = null;
=======
  late TextEditingController _newMaxTempController;
  late TextEditingController _newMinTempController;

  var _newMaxTemp;
  var _newMinTemp;
>>>>>>> 9b7a3b8a22ef3a7a4e9495445a5b0f24e7e84acb

  @override
  void initState() {
    super.initState();
    _newMaxTempController = TextEditingController();
    _newMinTempController = TextEditingController();

    _getData();

    _newMaxTempController.addListener(_updateTemp);
  }

  void _updateTemp() {
    setState(() {
      _newMaxTemp = _newMaxTempController.text;
      _newMinTemp = _newMinTempController.text;
    });
  }

  void _getData() async {
    _maxModel = (await ApiService().getMaxtemp());
    _minModel = (await ApiService().getMintemp());
    _verModel = (await ApiService().getVersion());
    _rotModel = (await ApiService().getRotation());


    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('REST API Example'),
        ),
        body: ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            return Card(
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text("Temperatura Maxima"),
                    ),
                    Text('${_maxModel!.maxtemp} °C'),
                    //Text(_maxModel!.message.toString()),
                    Flexible(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: TextField(
                        controller: _newMaxTempController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'nueva temperatura maxima'),
                      ),
                    )),
                    ElevatedButton(
                        onPressed: () => print(
                            'La temperatura maxima elegida es: ${_newMaxTempController.text}'),
                        child: Text('Set')),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Text("Temperatura Minima"),
                    ),
                    Text('${_minModel!.mintemp} °C'),
                    //Text(_maxModel!.message.toString()),
                    Flexible(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: TextField(
                        controller: _newMinTempController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'nueva temperatura minima'),
                      ),
                    )),
                    ElevatedButton(
                        onPressed: () => print(
                            'La temperatura minima elegida es: ${_newMinTempController.text}'),
                        child: Text('Set')),
                  ],
                ),
<<<<<<< HEAD
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Text("Tiempo de Rotación"),
                    ),
                    Text('${_rotModel!.rotation} ms'),
                    const Flexible(
                        child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'nuevo tiempo'),
                      ),
                    )),
                    ElevatedButton(
                        onPressed: () => print('blabla'), child: Text('Set')),
                  ],
                ),
                const SizedBox(height: 10),
=======
>>>>>>> 9b7a3b8a22ef3a7a4e9495445a5b0f24e7e84acb
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Text('Version: ${_verModel!.version}'),
                    ),
                  ],
                )
              ]),
            );
          },
        ));
  }
}
