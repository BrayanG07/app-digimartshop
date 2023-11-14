import 'dart:convert';

Ubication ubicationFromJson(String str) => Ubication.fromJson(json.decode(str));

String ubicationToJson(Ubication data) => json.encode(data.toJson());

class Ubication {
  String? idUbication;
  String address;
  String neighborhood;
  String refPoint;
  String latitude;
  String longitude;
  String? idUser;

  Ubication({
    this.idUbication,
    this.idUser,
    required this.address,
    required this.neighborhood,
    required this.refPoint,
    required this.latitude,
    required this.longitude,
  });

  factory Ubication.fromJson(Map<String, dynamic> json) => Ubication(
    idUbication: json["idUbication"],
    address: json["address"],
    neighborhood: json["neighborhood"],
    refPoint: json["refPoint"],
    latitude: json["latitude"],
    longitude: json["longitude"],
  );

  Map<String, dynamic> toJson() => {
    "idUbication": idUbication,
    "idUser": idUser,
    "address": address,
    "neighborhood": neighborhood,
    "refPoint": refPoint,
    "latitude": latitude,
    "longitude": longitude,
  };

  static List<Ubication> fromJsonList(List<dynamic> jsonList) {
    List<Ubication> toList = [];

    for (var item in jsonList) {
      Ubication ubication = Ubication.fromJson(item);
      toList.add(ubication);
    }

    return toList;
  }
}
