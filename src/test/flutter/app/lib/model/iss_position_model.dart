// To parse this JSON data, do
//
//     final issPosition = issPositionFromJson(jsonString);

import 'dart:convert';

IssPosition issPositionFromJson(String str) =>
    IssPosition.fromJson(json.decode(str));

String issPositionToJson(IssPosition data) => json.encode(data.toJson());

class IssPosition {
  IssPositionClass issPosition;
  int timestamp;
  String message;

  IssPosition({
    required this.issPosition,
    required this.timestamp,
    required this.message,
  });

  factory IssPosition.fromJson(Map<String, dynamic> json) => IssPosition(
        issPosition: IssPositionClass.fromJson(json["iss_position"]),
        timestamp: json["timestamp"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "iss_position": issPosition.toJson(),
        "timestamp": timestamp,
        "message": message,
      };
}

class IssPositionClass {
  String longitude;
  String latitude;

  IssPositionClass({
    required this.longitude,
    required this.latitude,
  });

  factory IssPositionClass.fromJson(Map<String, dynamic> json) =>
      IssPositionClass(
        longitude: json["longitude"],
        latitude: json["latitude"],
      );

  Map<String, dynamic> toJson() => {
        "longitude": longitude,
        "latitude": latitude,
      };
}
