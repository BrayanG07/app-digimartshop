import 'dart:convert';

SignInGoogle signInGoogleFromJson(String str) => SignInGoogle.fromJson(json.decode(str));

String ubicationToJson(SignInGoogle data) => json.encode(data.toJson());

class SignInGoogle {
  String email;
  String displayName;
  String photoUrl;
  String? phoneNumber;

  SignInGoogle({
    required this.email,
    required this.displayName,
    required this.photoUrl,
    this.phoneNumber,
  });

  factory SignInGoogle.fromJson(Map<String, dynamic> json) => SignInGoogle(
    email: json["email"],
    displayName: json["displayName"],
    photoUrl: json["photoUrl"],
    phoneNumber: json["phoneNumber"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "displayName": displayName,
    "photoUrl": photoUrl,
    "phoneNumber": phoneNumber,
  };
}
