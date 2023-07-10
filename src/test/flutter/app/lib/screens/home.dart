//import 'package:app/model/iss_position_model.dart';
import 'package:app/model/maxtemp_model.dart';
import 'package:app/model/mintemp_model.dart';
import 'package:flutter/material.dart';
//import 'package:app/model/user_model.dart';
import 'package:app/apiservice.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Maxtemp? _userModel = null;
  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    _userModel = (await ApiService().getMaxtemp());

    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('REST API Example'),
      ),
      body: _userModel == null
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
                        // segunda columna se actualize cuando aprieto el boton
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text("Temperatura actual:"),
                          Text(_userModel!.maxtemp.toString()),
                          Text(_userModel!.message),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                                onPrimary: Colors.white,
                                shadowColor: Colors.greenAccent,
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32.0)),
                                minimumSize: Size(100, 40),
                                textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontStyle: FontStyle.normal)),
                            child: const Text("Get Temp"),
                            //
                            onPressed: () {
                              _getData();
                              print("temperatura actual: " +
                                  _userModel!.maxtemp.toString());
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 30,
                        width: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Text("Tiempo de volteo:"),
                          const TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter a search term',
                            ),
                          ),
                          Text(_userModel!.maxtemp.toString()),
                          Text(_userModel!.message),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.green,
                                onPrimary: Colors.white,
                                shadowColor: Colors.greenAccent,
                                elevation: 3,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(32.0)),
                                minimumSize: Size(100, 40),
                                textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontStyle: FontStyle.normal)),
                            child: const Text("GET FlipTime"),
                            onPressed: () {
                              print("temperatura actual: " +
                                  _userModel!.maxtemp.toString());
                            },
                          ),
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
