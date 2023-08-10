import 'dart:io';

import 'package:jacksiltd/models/categories.dart';

class Product {
  final int id;
  final String productName;
  final String storeName;
  final double price;
  final double rating;
  final Categories category;
  final List<File>? images;

  Product({
    required this.id,
    required this.productName,
    required this.storeName,
    required this.price,
    required this.rating,
    required this.category,
    this.images,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productName': productName,
      'storeName': storeName,
      'price': price,
      'rating': rating,
      'category': category.index,
    };
  }
}
