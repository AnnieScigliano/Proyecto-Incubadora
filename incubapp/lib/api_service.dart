import 'dart:async';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:incubapp/constants.dart';
import 'package:incubapp/models/maxtemp_model.dart';
import 'package:incubapp/models/mintemp_model.dart';
import 'package:incubapp/models/version_model.dart';

// logica para consumo de datos en la api

class ApiService {
  Future<MaxTemp?> getMaxtemp() async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.maxTempEndPoint);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        MaxTemp model = maxTempFromJson(response.body);
        return model;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<Mintemp?> getMintemp() async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.minTempEndPoint);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        Mintemp model = mintempFromJson(response.body);
        return model;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }

  Future<Version?> getVersion() async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.versionEndPoint);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        Version model = versionFromJson(response.body);
        return model;
      }
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
}
