import 'dart:convert';

import 'package:digimartbox/src/models/order/shopping_cart.dart';

CreateOrder createOrderFromJson(String str) => CreateOrder.fromJson(json.decode(str));

String createOrderToJson(CreateOrder data) => json.encode(data.toJson());

class CreateOrder {
  String idUser;
  String paymentType;
  String? cardName;
  String? cardNumber;
  String? cardCvv;
  String? monthCard;
  String? yearCard;
  String? email;
  String? comment;
  String latitude;
  String longitude;
  String address;
  String addressDetail;
  double moneyToPay;
  List<ShoppingCart> shoppingCart;

  CreateOrder({
    required this.idUser,
    required this.paymentType,
    this.cardName,
    this.cardNumber,
    this.cardCvv,
    this.monthCard,
    this.yearCard,
    this.email,
    this.comment,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.moneyToPay,
    required this.addressDetail,
    required this.shoppingCart,
  });

  factory CreateOrder.fromJson(Map<String, dynamic> json) => CreateOrder(
    idUser: json["idUser"],
    paymentType: json["paymentType"],
    cardName: json["cardName"],
    cardNumber: json["cardNumber"],
    cardCvv: json["cardCvv"],
    monthCard: json["monthCard"],
    yearCard: json["yearCard"],
    email: json["email"],
    comment: json["comment"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    address: json["address"],
    moneyToPay: json["moneyToPay"],
    addressDetail: json["addressDetail"],
    shoppingCart: List<ShoppingCart>.from(json["products"].map((x) => ShoppingCart.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "idUser": idUser,
    "paymentType": paymentType,
    "cardName": cardName,
    "cardNumber": cardNumber,
    "cardCvv": cardCvv,
    "monthCard": monthCard,
    "yearCard": yearCard,
    "email": email,
    "comment": comment,
    "latitude": latitude,
    "longitude": longitude,
    "address": address,
    "addressDetail": addressDetail,
    "moneyToPay": moneyToPay,
    "products": List<dynamic>.from(shoppingCart.map((x) => x.toJson())),
  };
}
