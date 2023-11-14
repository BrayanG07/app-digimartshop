class Supermarket {
  String idSupermarket;
  String name;
  String latitude;
  String longitude;

  Supermarket({
    required this.idSupermarket,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory Supermarket.fromJson(Map<String, dynamic> json) => Supermarket(
    idSupermarket: json["idSupermarket"],
    name: json["name"],
    latitude: json["latitude"],
    longitude: json["longitude"],
  );

  Map<String, dynamic> toJson() => {
    "idSupermarket": idSupermarket,
    "name": name,
    "latitude": latitude,
    "longitude": longitude,
  };
}