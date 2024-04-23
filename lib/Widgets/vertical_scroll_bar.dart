import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ViewFoodItemsVertically extends StatefulWidget {
  final void Function() onTap;
  final String itemName;
  final String itemDetails;
  final String itemPrice;
  final String itemImgUrl;

  const ViewFoodItemsVertically(
      {super.key,
      required this.itemName,
      required this.itemDetails,
      required this.itemPrice,
      required this.itemImgUrl,
      required this.onTap});

  @override
  State<ViewFoodItemsVertically> createState() =>
      _ViewFoodItemsVerticallyState();
}

class _ViewFoodItemsVerticallyState extends State<ViewFoodItemsVertically> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: MediaQuery.sizeOf(context).height*0.01,horizontal: MediaQuery.sizeOf(context).height*0.01 ),

      child: GestureDetector(
        onTap: widget.onTap,
        child: Material(
          elevation: 5,
          // color: Colors.grey,
          borderRadius: BorderRadius.circular(10),
          child: Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.only(left: 5, top: 5, bottom: 5, right: 5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.network(
                    widget.itemImgUrl,
                    height: 100,
                    width: 150,
                    fit: BoxFit.cover,
                   errorBuilder: (context, error, stackTrace) {
                      return ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                     child: Image.asset(
                     "images/error_occured.png",
                     height: 100,
                     width: 150,
                     fit: BoxFit.contain,),);
                   },
                  ),

                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  children: [
                    Container(
                        width: MediaQuery.sizeOf(context).width / 3,
                        child: Text(
                        widget.itemName,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )),
                    Container(
                        width: MediaQuery.sizeOf(context).width / 3,
                        child: Text(
                          widget.itemDetails.length <30 ? widget.itemDetails : "${widget.itemDetails.substring(0,35)}..",
                          style: const TextStyle(color: Colors.black54, fontSize: 12),
                        )),
                    Container(
                        width: MediaQuery.sizeOf(context).width / 3,
                        child: Text(
                          "\$${widget.itemPrice}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
