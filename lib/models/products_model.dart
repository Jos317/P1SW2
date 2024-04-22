// To parse this JSON data, do
//
//     final products = productsFromJson(jsonString);

import 'dart:convert';

Products productsFromJson(String str) => Products.fromJson(json.decode(str));

String productsToJson(Products data) => json.encode(data.toJson());

class Products {
    final List<Product> products;

    Products({
        required this.products,
    });

    factory Products.fromJson(Map<String, dynamic> json) => Products(
        products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
    };
}

class Product {
    final int id;
    final String code;
    final String name;
    final String url;
    final String brand;
    final String description;
    final int quantity;
    final double price;
    int purchased;
    double buy;
    final Category category;

    Product({
        required this.id,
        required this.code,
        required this.name,
        required this.url,
        required this.brand,
        required this.description,
        required this.quantity,
        required this.price,
        this.purchased = 1,
        required this.category,
    }) : buy = price; // Inicializado con el valor de price;

    factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        code: json["code"],
        name: json["name"],
        url: json["url"],
        brand: json["brand"],
        description: json["description"],
        quantity: json["quantity"],
        price: json["price"].toDouble(),
        category: Category.fromJson(json["category"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "name": name,
        "url": url,
        "brand": brand,
        "description": description,
        "quantity": quantity,
        "price": price,
        "category": category.toJson(),
    };
}

class Category {
    final int id;
    final String name;

    Category({
        required this.id,
        required this.name,
    });

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}
