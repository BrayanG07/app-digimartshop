import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  DateTime? createdAt;
  DateTime? updatedAt;
  String? idUser;
  String? lastName;
  String? firstName;
  dynamic image;
  String? email;
  String? emailSponsor;
  String? phone;
  String? dni;
  String? password;
  String? confirmationPassword;
  String? status;
  String? token;
  String? role;

  User({
    this.createdAt,
    this.updatedAt,
    this.idUser,
    this.firstName,
    this.lastName,
    this.email,
    this.emailSponsor,
    this.image,
    this.phone,
    this.dni,
    this.password,
    this.confirmationPassword,
    this.status,
    this.token,
    this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    idUser: json["idUser"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    dni: json["dni"],
    phone: json["phone"],
    password: json["password"],
    confirmationPassword: json["confirmationPassword"],
    email: json["email"],
    emailSponsor: json["emailSponsor"],
    image: json["image"],
    status: json["status"],
    token: json["token"],
    role: json["role"],
  );

  Map<String, dynamic> toJson() => {
    "createdAt": createdAt?.toIso8601String() ?? '',
    "updatedAt": updatedAt?.toIso8601String() ?? '',
    "idUser": idUser,
    "password": password,
    "confirmationPassword": confirmationPassword,
    "status": status,
    "firstName": firstName,
    "lastName": lastName,
    "phone": phone,
    "email": email,
    "emailSponsor": emailSponsor,
    "image": image,
    "dni": dni,
    "token": token,
    "role": role
  };

  static List<User> fromJsonList(List<dynamic> jsonList) {
    List<User> toList = [];

    for (var item in jsonList) {
      User value = User.fromJson(item);
      toList.add(value);
    }

    return toList;
  }
}