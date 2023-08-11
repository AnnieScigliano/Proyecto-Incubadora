import 'dart:convert';

MaxTemp maxTempFromJson(String str) => MaxTemp.fromJson(json.decode(str));

String maxTempToJson(MaxTemp data) => json.encode(data.toJson());

class MaxTemp {
  String message;
  int maxtemp;

  MaxTemp({
    required this.message,
    required this.maxtemp,
  });

  factory MaxTemp.fromJson(Map<String, dynamic> json) => MaxTemp(
        message: json["message"],
        maxtemp: json["maxtemp"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "maxtemp": maxtemp,
      };
}
