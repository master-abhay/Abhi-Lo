import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class FoodOption extends StatefulWidget {
  final imageName;
  final foodType;
  final Function() onTap;
  final color;

  const FoodOption({super.key,required this.foodType, required this.imageName, required this.onTap, required this.color
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
          shadowColor: widget.color,


          elevation: 5,
          child: Column(
            children: [
              Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  color: widget.color
                ),
                // height: MediaQuery.sizeOf(context).height*0.1,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  // child: Image.asset(
                  //   "images/${widget.imageName}",
                  //
                  //   fit: BoxFit.cover,
                  //
                  // ),
                  child: Lottie.asset(
                    "images/${widget.imageName}",

                    fit: BoxFit.cover,

                  ),
                ),
              ),
              Text(widget.foodType,style: const TextStyle(fontWeight: FontWeight.w600),)
            ],
          ),
        ),
      ),
    );
  }
}
