import 'dart:convert';

import 'package:digimartbox/src/models/order/order_detail.dart';
import 'package:digimartbox/src/models/supermarket/supermarket.dart';
import 'package:digimartbox/src/models/user/delivery.dart';
import 'package:digimartbox/src/models/user/user.dart';

List<OrderListUser> orderListUserFromJson(String str) => List<OrderListUser>.from(json.decode(str).map((x) => OrderListUser.fromJson(x)));

String orderListUserToJson(List<OrderListUser> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class OrderListUser {
  DateTime createdAt;
  DateTime updatedAt;
  String idOrder;
  int total;
  int totalDiscount;
  int totalIsv;
  String paymentType;
  String startNumberCai;
  String endNumberCai;
  String vaucherNumber;
  String comment;
  String latitude;
  String longitude;
  String address;
  String addressDetail;
  String moneyToPay;
  String status;
  List<OrderDetail> orderDetail;
  Delivery? userDelivery;
  Supermarket supermarket;

  OrderListUser({
    required this.createdAt,
    required this.updatedAt,
    required this.idOrder,
    required this.total,
    required this.totalDiscount,
    required this.totalIsv,
    required this.paymentType,
    required this.startNumberCai,
    required this.endNumberCai,
    required this.vaucherNumber,
    required this.comment,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.addressDetail,
    required this.moneyToPay,
    required this.status,
    required this.orderDetail,
    required this.supermarket,
    this.userDelivery,
  });

  factory OrderListUser.fromJson(Map<String, dynamic> json) => OrderListUser(
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    idOrder: json["idOrder"],
    total: json["total"],
    totalDiscount: json["totalDiscount"],
    totalIsv: json["totalIsv"],
    paymentType: json["paymentType"],
    startNumberCai: json["start_number_cai"],
    endNumberCai: json["end_number_cai"],
    vaucherNumber: json["vaucher_number"],
    comment: json["comment"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    address: json["address"],
    addressDetail: json["addressDetail"],
    moneyToPay: json["moneyToPay"],
    status: json["status"],
    orderDetail: List<OrderDetail>.from(json["orderDetail"].map((x) => OrderDetail.fromJson(x))),
    userDelivery: json['userDelivery'] != null ? Delivery.fromJson(json["userDelivery"]) : null,
    supermarket: Supermarket.fromJson(json["supermarket"]),
  );

  Map<String, dynamic> toJson() => {
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "idOrder": idOrder,
    "total": total,
    "totalDiscount": totalDiscount,
    "totalIsv": totalIsv,
    "paymentType": paymentType,
    "start_number_cai": startNumberCai,
    "end_number_cai": endNumberCai,
    "vaucher_number": vaucherNumber,
    "comment": comment,
    "latitude": latitude,
    "longitude": longitude,
    "address": address,
    "addressDetail": addressDetail,
    "moneyToPay": moneyToPay,
    "status": status,
    "orderDetail": List<dynamic>.from(orderDetail.map((x) => x.toJson())),
    "userDelivery": userDelivery?.toJson(),
    "supermarket": supermarket.toJson(),
  };

  static List<OrderListUser> fromJsonList(List<dynamic> jsonList) {
    List<OrderListUser> toList = [];

    for (var item in jsonList) {
      OrderListUser value = OrderListUser.fromJson(item);
      toList.add(value);
    }

    return toList;
  }
}
