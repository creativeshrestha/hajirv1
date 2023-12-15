// To parse this JSON data, do
//
//     final week = weekFromJson(jsonString);

import 'dart:convert';

List<Week> weekFromJson(String str) =>
    List<Week>.from(json.decode(str).map((x) => Week.fromJson(x)));

String weekToJson(List<Week> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Week {
  String name;
  String from;
  String to;

  Week({
    required this.name,
    required this.from,
    required this.to,
  });

  factory Week.fromJson(Map<String, dynamic> json) => Week(
        name: json["name"],
        from: json["from"],
        to: json["to"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "from": from,
        "to": to,
      };
}
