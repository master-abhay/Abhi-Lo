import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FoodOption extends StatefulWidget {
  final imageName;
  final Function() onTap;
  final color;

  const FoodOption({super.key, required this.imageName, required this.onTap, required this.color
      });

  @override
  State<FoodOption> createState() => _FoodOptionState();
}

class _FoodOptionState extends State<FoodOption> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Material(
          borderRadius: BorderRadius.circular(10),

          elevation: 10,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              color: widget.color
            ),
            // height: MediaQuery.sizeOf(context).height*0.1,
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Image.asset(
                "images/${widget.imageName}",
                height: 55,
                width: 55,
                fit: BoxFit.fill,

              ),
            ),
          ),
        ),
      ),
    );
  }
}
