import 'dart:convert';

import 'package:digimartbox/src/models/supermarket/supermarket.dart';

List<Department> departmentFromJson(String str) => List<Department>.from(json.decode(str).map((x) => Department.fromJson(x)));

String departmentToJson(List<Department> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Department {
  String idDepartment;
  String name;
  List<Supermarket> supermarket;

  Department({
    required this.idDepartment,
    required this.name,
    required this.supermarket,
  });

  factory Department.fromJson(Map<String, dynamic> json) => Department(
    idDepartment: json["idDepartment"],
    name: json["name"],
    supermarket: List<Supermarket>.from(json["supermarket"].map((x) => Supermarket.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "idDepartment": idDepartment,
    "name": name,
    "supermarket": List<dynamic>.from(supermarket.map((x) => x.toJson())),
  };

  static List<Department> fromJsonList(List<dynamic> jsonList) {
    List<Department> toList = [];

    for (var item in jsonList) {
      Department category = Department.fromJson(item);
      toList.add(category);
    }

    return toList;
  }
}
