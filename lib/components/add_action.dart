import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({super.key, this.onClick, required this.icon});
  final Function()? onClick;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          icon == Icons.add ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onClick,
          child: Container(
            height: 40,
            width: 40,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset:
                      const Offset(0, 0), // Adjust the shadow offset as needed
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
