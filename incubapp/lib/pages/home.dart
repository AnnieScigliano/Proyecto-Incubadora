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
  late final List _list_Models = [
    _maxModel!.maxtemp,
    _minModel!.mintemp,
    _verModel!.version,
  ];

  late final List _list_min_max_ver = [
    "Temperatura maxima",
    "Temperatura minima",
    "Version"
  ];

  late final List<String> _list_icons = ['AssetImage("lib/images/temp.png")'];

  late MaxTemp? _maxModel = null;
  late Mintemp? _minModel = null;
  late Version? _verModel = null;
  // late var new_maxmodel = null;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    _maxModel = (await ApiService().getMaxtemp())!;
    _minModel = (await ApiService().getMintemp());
    _verModel = (await ApiService().getVersion());

    print(_maxModel?.maxtemp.toString());
    print(_minModel?.mintemp.toString());

    // _list_Models.add(_minModel);
    // _list_Models.add(_verModel);

    //print(_minModel!.mintemp.toString());
    // print(_verModel!.version.toString());

    Future.delayed(const Duration(seconds: 1)).then((value) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración de parámetros'),
      ),
      body: _maxModel == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _list_Models
                  .length, // cantidad de veces que va iterar la lista
              itemBuilder: (context, index) {
                return ListTile(
                  onLongPress: () {
                    _updatemaxtemp(context, _maxModel!.maxtemp);
                  },
                  title: Text(_list_min_max_ver[index].toString()),
                  subtitle: Text(
                    _list_Models[index]!.toString(),
                    style: const TextStyle(
                        color: Colors.green, fontFamily: "RobotoMono"),
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 20,
                    backgroundImage: AssetImage(_image_path(index)),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios_outlined),
                );
              },
            ),
    );
  }

  _image_path(index) {
    if (_list_min_max_ver[index].toString() == "Temperatura maxima") {
      return "lib/images/max_temp.png";
    } else if (_list_min_max_ver[index].toString() == "Temperatura minima") {
      return "lib/images/min_temp.png";
    } else if (_list_min_max_ver[index].toString() == "Version") {
      return "lib/images/version.png";
    }
  }

  _updatemaxtemp(context, new_maxmodel) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: const Text("Actualizar parametros"),
              content: const Text("¿desea actualizar los parametros?"),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancelar")),
                ElevatedButton(
                    onPressed: () {
                      new_maxmodel = ApiService().getMaxtemp();
                      print(new_maxmodel);
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Actualizar",
                    )),
              ],
            ));
  }
}
