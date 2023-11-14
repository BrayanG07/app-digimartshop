class ShoppingCart {
  String idProduct;
  String idStock;
  String idSupermarket;
  String nameProduct;
  String imageProduct;
  String descriptionProduct;
  int quantity;
  double price;

  ShoppingCart({
    required this.idProduct,
    required this.idStock,
    required this.nameProduct,
    required this.imageProduct,
    required this.descriptionProduct,
    required this.idSupermarket,
    required this.quantity,
    required this.price,
  });

  factory ShoppingCart.fromJson(Map<String, dynamic> json) => ShoppingCart(
    idProduct: json["idProduct"],
    idStock: json["idStock"],
    idSupermarket: json["idSupermarket"],
    nameProduct: json["nameProduct"],
    imageProduct: json["imageProduct"],
    descriptionProduct: json["descriptionProduct"],
    quantity: json["quantity"],
    price: json["price"],
  );

  Map<String, dynamic> toJson() => {
    "idProduct": idProduct,
    "idStock": idStock,
    "idSupermarket": idSupermarket,
    "nameProduct": nameProduct,
    "imageProduct": imageProduct,
    "descriptionProduct": descriptionProduct,
    "quantity": quantity,
    "price": price,
  };

  static List<ShoppingCart> fromJsonList(List<dynamic> jsonList) {
    List<ShoppingCart> toList = [];

    for (var item in jsonList) {
      ShoppingCart product = ShoppingCart.fromJson(item);
      toList.add(product);
    }

    return toList;
  }
}