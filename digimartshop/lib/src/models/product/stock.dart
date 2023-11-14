class Stock {
  String idStock;
  int stock;

  Stock({
    required this.idStock,
    required this.stock,
  });

  factory Stock.fromJson(Map<String, dynamic> json) => Stock(
    idStock: json["idStock"],
    stock: json["stock"],
  );

  Map<String, dynamic> toJson() => {
    "idStock": idStock,
    "stock": stock,
  };
}
