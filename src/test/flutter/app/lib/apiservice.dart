import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:app/constants.dart';
import 'package:app/model/user_model.dart';
import 'package:app/model/iss_position_model.dart';
import 'package:app/model/maxtemp_model.dart';
import 'package:app/model/mintemp_model.dart';

class ApiService {
  Future<List<Users>?> getUsers() async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpoint);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        List<Users> _model = usersFromJson(response.body);
        return _model;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<IssPosition?> getPosition() async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.isnowEndpoint);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        IssPosition _model = issPositionFromJson(response.body);
        return _model;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<Maxtemp?> getMaxtemp() async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.maxtempEndpoint);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        Maxtemp _model = maxtempFromJson(response.body);
        return _model;
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<Mintemp?> getMintemp() async {
    try {
      var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.mintempEndpoint);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        Mintemp _model = mintempFromJson(response.body);
        return _model;
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
