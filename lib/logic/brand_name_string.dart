import 'package:jacksiltd/models/categories.dart';

String brandName(Categories brand) {
  String name;

  if (brand == Categories.all) {
    name = 'الكل';
  } else if (brand == Categories.category1) {
    name = 'تصنيف1';
  } else if (brand == Categories.category2) {
    name = 'تصنيف2';
  } else if (brand == Categories.category3) {
    name = 'تصنيف3';
  } else {
    name = '';
  }
  return name;
}
