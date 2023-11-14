class OrderDetail {
  DateTime createdAt;
  DateTime updatedAt;
  String idOrderDetail;
  String nameProduct;
  String imageProduct;
  int isvProduct;
  int discountProduct;
  int priceProduct;
  int quantity;
  String status;

  OrderDetail({
    required this.createdAt,
    required this.updatedAt,
    required this.idOrderDetail,
    required this.nameProduct,
    required this.imageProduct,
    required this.isvProduct,
    required this.discountProduct,
    required this.priceProduct,
    required this.quantity,
    required this.status,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    idOrderDetail: json["idOrderDetail"],
    nameProduct: json["nameProduct"],
    imageProduct: json["imageProduct"],
    isvProduct: json["isvProduct"],
    discountProduct: json["discountProduct"],
    priceProduct: json["priceProduct"],
    quantity: json["quantity"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "idOrderDetail": idOrderDetail,
    "nameProduct": nameProduct,
    "imageProduct": imageProduct,
    "isvProduct": isvProduct,
    "discountProduct": discountProduct,
    "priceProduct": priceProduct,
    "quantity": quantity,
    "status": status,
  };
}