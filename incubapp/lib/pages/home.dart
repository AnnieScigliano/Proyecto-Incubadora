// import de modelos de datos

import 'package:incubapp/models/maxtemp_model.dart';
import 'package:incubapp/models/mintemp_model.dart';
import 'package:incubapp/models/version_model.dart';

// import de widgets
import 'package:flutter/material.dart';

// import de api service
import 'package:incubapp/api_service.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<MaxTemp?> _list_MaxModel = [];
  late MaxTemp? _maxModel = null;
  //late Mintemp? _minModel = null;
  //late Version? _verModel = null;
  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    _maxModel = (await ApiService().getMaxtemp())!;
    //_minModel = (await ApiService().getMintemp());
    //_verModel = (await ApiService().getVersion());

    print(_maxModel?.maxtemp.toString());
    _list_MaxModel.add(_maxModel);
    //print(_minModel!.mintemp.toString());
    // print(_verModel!.version.toString());

    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('REST API Example'),
      ),
      body: _maxModel == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _list_MaxModel.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(_list_MaxModel[index]!.maxtemp.toString()),
                          Text(_list_MaxModel[index]!.message.toString()),
                        ],
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(_list_MaxModel[index]!.message),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
