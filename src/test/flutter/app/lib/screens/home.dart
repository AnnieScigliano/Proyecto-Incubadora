//import 'package:app/model/iss_position_model.dart';
import 'package:app/model/maxtemp_model.dart';
import 'package:app/model/mintemp_model.dart';
import 'package:app/model/version_model.dart';
import 'package:flutter/material.dart';
//import 'package:app/model/user_model.dart';
import 'package:app/apiservice.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Maxtemp? _maxModel = null;
  late Mintemp? _minModel = null;
  late Version? _verModel = null;
  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    _maxModel = (await ApiService().getMaxtemp());
    _minModel = (await ApiService().getMintemp());
    _verModel = (await ApiService().getVersion());
    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PARÁMETROS'),
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
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Temperatura máxima permitida:'),
                          Text(_maxModel!.maxtemp.toString() + '°C'),
                          Text(_maxModel!.message),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Temperatura mínima permitida:'),
                          Text(_minModel!.mintemp.toString() + '°C'),
                          Text(_minModel!.message),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('Versión:'),
                          Text(_verModel!.version.toString()),
                          Text(_verModel!.message),
                          Flexible(
                            child: TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter a search term',
                              ),
                            ),
                          ),
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
