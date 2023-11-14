import 'dart:convert';

Category categoryFromJson(String str) => Category.fromJson(json.decode(str));

class Category {
  DateTime? createdAt;
  DateTime? updatedAt;
  String? idCategory;
  String? name;
  String? description;
  dynamic image;
  String? status;

  Category({
    this.createdAt,
    this.updatedAt,
    this.idCategory,
    this.name,
    this.description,
    this.image,
    this.status,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    idCategory: json["idCategory"],
    name: json["name"],
    description: json["description"],
    image: json["image"],
    status: json["status"],
  );

  static List<Category> fromJsonList(List<dynamic> jsonList) {
    List<Category> toList = [];

    for (var item in jsonList) {
      Category category = Category.fromJson(item);
      toList.add(category);
    }

    return toList;
  }
}