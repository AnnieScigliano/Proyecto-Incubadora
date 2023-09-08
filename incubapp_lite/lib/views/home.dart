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
  late Rotation? _rotModel = null;

  @override
  void initState() {
    super.initState();
    _getData();
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
                    const Flexible(
                        child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'nueva temp'),
                      ),
                    )),
                    ElevatedButton(
                        onPressed: () => print('blabla'), child: Text('Set')),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Temperatura minima:'),
                    Text('${_minModel!.mintemp} °C'),
                    Text(_minModel!.message.toString()),
                  ],
                ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Version:'),
                    Text(_verModel!.version.toString()),
                    Text(_verModel!.message.toString()),
                  ],
                )
              ]),
            );
          },
        ));
  }
}
