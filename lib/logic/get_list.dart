import 'package:jacksiltd/data/fakedata.dart';
import 'package:jacksiltd/data/insert_products.dart';
import 'package:jacksiltd/models/product.dart';
import 'package:jacksiltd/models/categories.dart';

Future<List<Product>> getProductFor({required Categories model}) async {
  late List<Product> productList = fakeProductList;
  productList.addAll(await DatabaseHelper.instance.fetchProducts());
  return productList.reversed.toList();
}
