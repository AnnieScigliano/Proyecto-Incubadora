import 'dart:async';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:incubapp_lite/utils/constants.dart';
import 'package:incubapp_lite/models/max_temp_model.dart';
import 'package:incubapp_lite/models/min_temp_model.dart';
import 'package:incubapp_lite/models/version_model.dart';

// logica para consumo de datos en la api

class ApiService {
  Future<Maxtemp?> getMaxtemp() async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.maxTempEndPoint);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        Maxtemp model = maxtempFromJson(response.body);
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
