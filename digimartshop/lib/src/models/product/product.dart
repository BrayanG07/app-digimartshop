import 'dart:convert';

import 'package:digimartbox/src/models/product/stock.dart';

List<Product> productFromJson(String str) => List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
  String idProduct;
  String name;
  String price;
  String image;
  String description;
  List<Stock> stock;
  int? quantity;

  Product({
    required this.idProduct,
    required this.name,
    required this.price,
    required this.image,
    required this.description,
    required this.stock,
    this.quantity
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    idProduct: json["idProduct"],
    name: json["name"],
    price: json["price"],
    image: json["image"],
    description: json["description"],
    quantity: json["quantity"],
    stock: List<Stock>.from(json["stock"].map((x) => Stock.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "idProduct": idProduct,
    "name": name,
    "price": price,
    "image": image,
    "description": description,
    "quantity": quantity,
    "stock": List<dynamic>.from(stock.map((x) => x.toJson())),
  };

  static List<Product> fromJsonList(List<dynamic> jsonList) {
    List<Product> toList = [];

    for (var item in jsonList) {
      Product product = Product.fromJson(item);
      toList.add(product);
    }

    return toList;
  }
}