import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:app/constants.dart';
import 'package:app/model/user_model.dart';
import 'package:app/model/iss_position_model.dart';

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
}
