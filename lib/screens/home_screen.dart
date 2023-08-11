import 'package:flutter/material.dart';
import 'package:jacksiltd/components/add_action.dart';
import 'package:jacksiltd/components/list_card.dart';
import 'package:jacksiltd/data/database_products.dart';
import 'package:jacksiltd/designSystem.dart';
import 'package:jacksiltd/models/categories.dart';
import 'package:jacksiltd/components/grid_card.dart';
import 'package:jacksiltd/logic/brand_name_string.dart';
import 'package:jacksiltd/logic/get_list.dart';
import 'package:jacksiltd/models/product.dart';
import 'package:jacksiltd/screens/add_product.dart';
import 'package:sqflite/sqflite.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Categories model = Categories.all;
  List<Product> list = [];
  List<Product> alllist = [];
  var currentCategory = 0;
  var type = 'list';
  @override
  void initState() {
    super.initState();
    getProducts();
  }

  getProducts() async {
    alllist.clear();
    var value = await getProductFor(model: model);
    alllist = value;
    list = List.from(alllist);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // DatabaseHelper.instance.clearDatabase();
    return Scaffold(
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(child: SizedBox()),
                      const Center(
                          child: Text(
                        'المنتجات',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24),
                      )),
                      Expanded(
                        child: ActionButton(
                            icon: Icons.add,
                            onClick: () => Navigator.of(context)
                                .push(MaterialPageRoute(
                                  builder: (context) => const AddProductPage(),
                                ))
                                .then((value) => getProducts())),
                      ),
                    ]),
                SizedBox(
                    width: double.infinity,
                    child: Row(
                        children: List.generate(
                            4,
                            (i) => Expanded(
                                  child: GestureDetector(
                                    onTap: () async {
                                      model = Categories.values[i];
                                      list = List.from(alllist);
                                      if (model != Categories.all) {
                                        list = list
                                            .where(
                                              (e) => e.category == model,
                                            )
                                            .toList();
                                      }
                                      setState(() {
                                        currentCategory = i;
                                      });
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                        left: 5,
                                        right: 5,
                                        top: 20,
                                        bottom: 20,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          border: currentCategory == i
                                              ? Border.all(
                                                  color: AppColors.green)
                                              : null),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Image.asset(
                                            'assets/category/category$i.png',
                                          ),
                                          Center(
                                            child: Text(
                                              brandName(Categories.values[i]),
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 1,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )))),
                Row(
                  children: [
                    const Spacer(),
                    GestureDetector(
                      onTap: () => setState(() {
                        type = (type == 'list' ? "grid" : "list");
                      }),
                      child: Card(
                          child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Icon(
                                  type == 'list' ? Icons.apps : Icons.list,
                                  color: AppColors.filterColor),
                            ),
                            Text(
                              'تغير عرض المنتجات الي ${type == 'list' ? "افقي" : "رأسي"}',
                              style:
                                  const TextStyle(color: AppColors.filterColor),
                            ),
                          ],
                        ),
                      )),
                    ),
                  ],
                ),
                Expanded(
                  child: type == 'grid'
                      ? GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 0.8,
                          ),
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            return GridCard(product: list[index]);
                          },
                        )
                      : ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            return ListCard(product: list[index]);
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
