// To parse this JSON data, do
//
//     final mintemp = mintempFromJson(jsonString);

import 'dart:convert';

Mintemp mintempFromJson(String str) => Mintemp.fromJson(json.decode(str));

String mintempToJson(Mintemp data) => json.encode(data.toJson());

class Mintemp {
  String message;
  int mintemp;

  Mintemp({
    required this.message,
    required this.mintemp,
  });

  factory Mintemp.fromJson(Map<String, dynamic> json) => Mintemp(
        message: json["message"],
        mintemp: json["mintemp"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "mintemp": mintemp,
    };
}
