// To parse this JSON data, do
//
//     final delivery = deliveryFromJson(jsonString);

import 'dart:convert';
import 'package:digimartbox/src/models/user/user.dart';

Delivery deliveryFromJson(String str) => Delivery.fromJson(json.decode(str));

String deliveryToJson(Delivery data) => json.encode(data.toJson());

class Delivery {
  String idDelivery;
  double latitude;
  double longitude;
  String status;
  User user;

  Delivery({
    required this.idDelivery,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.user,
  });

  factory Delivery.fromJson(Map<String, dynamic> json) => Delivery(
    idDelivery: json["idDelivery"],
    latitude: json["latitude"] != null ? double.parse(json["latitude"].toString()) : 0,
    longitude: json["longitude"] != null ? double.parse(json["longitude"].toString()) : 0,
    status: json["status"],
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "idDelivery": idDelivery,
    "latitude": latitude,
    "longitude": longitude,
    "status": status,
    "user": user.toJson(),
  };
}
