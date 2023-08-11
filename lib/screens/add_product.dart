import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jacksiltd/components/add_action.dart';
import 'package:jacksiltd/data/database_products.dart';
import 'package:jacksiltd/designSystem.dart';
import 'package:jacksiltd/logic/brand_name_string.dart';
import 'package:jacksiltd/models/categories.dart';
import 'package:jacksiltd/models/product.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';

class AddProductPage extends StatefulWidget {
  const AddProductPage({Key? key}) : super(key: key);

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  List<File> _pickedImages = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController productNameController = TextEditingController();
  TextEditingController storeNameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  double rating = 0.0;
  Categories selectedCategory = Categories.category1; // Default category

  Future<void> _pickImages() async {
    final pickedImages = await ImagePicker().pickMultiImage();

    setState(() {
      _pickedImages =
          pickedImages.map((pickedImage) => File(pickedImage.path)).toList();
    });
  }

  Future<void> _deleteImages(i) async {
    setState(() {
      _pickedImages.removeAt(i);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: ActionButton(
                            onClick: () => Navigator.of(context).pop(),
                            icon: Icons.arrow_back,
                          ),
                        ),
                        const Center(
                          child: Text(
                            'اضافة المنتجات',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      children: List.generate(4, (i) {
                        if (i < _pickedImages.length) {
                          return Expanded(
                            child: Stack(
                              alignment: Alignment.topLeft,
                              children: [
                                Container(
                                  height: 90,
                                  margin: const EdgeInsets.all(3),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(7),
                                    child: Image.file(
                                      _pickedImages[i],
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => _deleteImages(i),
                                  child: Container(
                                    width: 24,
                                    height: 24,
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        } else {
                          return Expanded(
                            child: Container(
                              height: 90,
                              margin: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  color: Colors.white),
                              child: const Icon(Icons.add_photo_alternate,
                                  color: AppColors.green),
                            ),
                          );
                        }
                      }),
                    ),
                    const SizedBox(height: 16.0),
                    Mybutton(
                        onClick: () => _pickImages(),
                        label: 'اضغط هنا لاضافة الصور',
                        icon: Icons.add),
                    const SizedBox(height: 16.0),
                    TextInput(
                      controller: productNameController,
                      label: 'اسم المنتج',
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 5) {
                          return 'يرجى إدخال اسم المتجر (على الأقل 5 أحرف)';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextInput(
                      controller: storeNameController,
                      label: 'اسم المتجر',
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 5) {
                          return 'يرجى إدخال اسم المتجر (على الأقل 5 أحرف)';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextInput(
                      controller: priceController,
                      label: 'سعر المنتج',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال سعر المنتج';
                        }
                        final double? parsedValue = double.tryParse(value);
                        if (parsedValue == null || parsedValue <= 0) {
                          return 'الرجاء إدخال قيمة سعر صحيحة وأكبر من الصفر';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    const CustomStyledDropdownButton(),
                    Row(
                      children: [
                        const Text('التقييم : '),
                        Slider(
                          value: rating,
                          onChanged: (newRating) {
                            setState(() {
                              rating = newRating;
                            });
                          },
                          min: 0,
                          max: 5,
                          divisions: 50,
                        ),
                        Text(rating.toStringAsFixed(1)),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Mybutton(
                      onClick: () {
                        if (_formKey.currentState!.validate()) {
                          saveProduct().then((value) => Navigator.pop(context));
                        }
                      },
                      label: 'اضغط هنا لاضافة الصور',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> saveProduct() async {
    final productName = productNameController.text;
    final storeName = storeNameController.text;
    final price = double.parse(priceController.text);

    final newProduct = Product(
      id: DateTime.now().millisecondsSinceEpoch,
      productName: productName,
      storeName: storeName,
      price: price,
      rating: rating,
      category: selectedCategory,
    );

    final productId = await DatabaseHelper.instance.insertProduct(newProduct);

    if (_pickedImages.isNotEmpty) {
      for (File imageFile in _pickedImages) {
        final imagePath = await saveImageToLocalDirectory(imageFile);
        await DatabaseHelper.instance.insertImagePath(productId, imagePath);
      }
    }
  }

  Future<String> saveImageToLocalDirectory(File imageFile) async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    final String fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final String imagePath = '${appDir.path}/$fileName';
    await imageFile.copy(imagePath);
    return imagePath;
  }
}

class Mybutton extends StatelessWidget {
  const Mybutton({super.key, this.onClick, required this.label, this.icon});
  final Function()? onClick;
  final String label;
  final IconData? icon;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: AppColors.green,
          border: Border.all(
            color: Colors.grey.withOpacity(.2),
            width: 2.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              const Card(
                child: Icon(Icons.add, color: AppColors.green, size: 20),
              ),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}

class CustomStyledDropdownButton extends StatefulWidget {
  const CustomStyledDropdownButton({super.key});

  @override
  _CustomStyledDropdownButtonState createState() =>
      _CustomStyledDropdownButtonState();
}

class _CustomStyledDropdownButtonState
    extends State<CustomStyledDropdownButton> {
  Categories? selectedCategory = Categories.category1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white,
        border: Border.all(
          color: Colors.grey.withOpacity(.2),
          width: 2.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: DropdownButton<Categories>(
          value: selectedCategory,
          onChanged: (newCategory) {
            setState(() {
              selectedCategory = newCategory!;
            });
          },
          items: Categories.values.sublist(1).map<DropdownMenuItem<Categories>>(
            (Categories value) {
              return DropdownMenuItem<Categories>(
                value: value,
                child: Text(brandName(value)),
              );
            },
          ).toList(),
          underline: Container(), // Remove the default underline
          style: TextStyle(
            color: Colors.grey.withOpacity(.7),
          ),
          icon: const Icon(Icons.arrow_drop_down_circle_outlined,
              color: Colors.blueGrey),
          isExpanded: true,
        ),
      ),
    );
  }
}

class TextInput extends StatelessWidget {
  const TextInput({
    super.key,
    required this.controller,
    required this.label,
    this.validator,
    this.keyboardType, // Add the keyboardType property
  });

  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType; // Define the keyboardType property

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white,
        border: Border.all(
          color: Colors.grey.withOpacity(.2),
          width: 2.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 8.0), // You can adjust the padding as needed
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType, // Set the keyboardType
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(
              color: Colors.grey.withOpacity(.7),
            ),
            border: InputBorder.none,
          ),
          validator: validator,
        ),
      ),
    );
  }
}
