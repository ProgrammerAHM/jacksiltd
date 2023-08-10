import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jacksiltd/data/insert_products.dart';
import 'package:jacksiltd/designSystem.dart';
import 'package:jacksiltd/models/product.dart';

class GridCard extends StatefulWidget {
  final Product product;

  const GridCard({Key? key, required this.product}) : super(key: key);

  @override
  State<GridCard> createState() => _GridCardState();
}

class _GridCardState extends State<GridCard> {
  var _isFavorite = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider _getImageProvider() {
      if (widget.product.images != null && widget.product.images!.isNotEmpty) {
        return FileImage(File(widget.product.images![0].path));
      } else {
        return const AssetImage("assets/empty.png");
      }
    }

    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 180,
        width: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Spacer(),
                SvgPicture.asset(
                  'assets/svg/star.svg',
                  height: 18,
                  width: 18,
                ),
                const SizedBox(width: 5),
                Text(
                  widget.product.rating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Hero(
                tag: widget.product.images ?? [0],
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      image: _getImageProvider(),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.product.price.toStringAsFixed(2),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.green,
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          'دولار',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .25,
                      child: Text(
                        widget.product.productName,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: _isFavorite
                      ? const Icon(
                          Icons.favorite,
                          color: Colors.red,
                        )
                      : const Icon(Icons.favorite_border_outlined),
                  onPressed: () {
                    setState(() {
                      _isFavorite = !_isFavorite;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
