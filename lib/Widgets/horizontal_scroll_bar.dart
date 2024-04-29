import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ViewFoodItemsHorizontally extends StatefulWidget {

  final Function() onTap;
  final String itemName;
  final String itemDetails;
  final String itemPrice;
  final String itemImgUrl;
  const ViewFoodItemsHorizontally({super.key, required this.onTap,required this.itemName,
    required this.itemDetails,
    required this.itemPrice,
    required this.itemImgUrl});

  @override
  State<ViewFoodItemsHorizontally> createState() =>
      _ViewFoodItemsHorizontallyState();
}

class _ViewFoodItemsHorizontallyState extends State<ViewFoodItemsHorizontally> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Padding(
        padding:  EdgeInsets.symmetric(horizontal: MediaQuery.sizeOf(context).width*0.01,vertical: MediaQuery.sizeOf(context).width*0.02),
        child: Material(
          // color: Colors.grey,
          elevation: 20,
          borderRadius: BorderRadius.circular(10),
          child: Container(

            padding: EdgeInsets.symmetric(horizontal: MediaQuery.sizeOf(context).width*0.02,vertical:MediaQuery.sizeOf(context).height*0.02 ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container
                        (
                        height: MediaQuery.of(context).size.height*0.15,
                        width: MediaQuery.of(context).size.width*0.5,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.network(
                            widget.itemImgUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              // Return a custom error widget when image fails to load
                              return Container(
                                height:110,
                                width: 170,
                                child: ClipRRect(
                                  child: Image.asset(
                                    "images/error_occured.png",
                                    fit: BoxFit.contain,

                                  ),
                                ),
                              ); // You can replace this with any custom error widget
                            },
                          ),

                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.005,
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: MediaQuery.sizeOf(context).width * 0.02),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.itemName.length < 20 ? widget.itemName : "${widget.itemName.substring(0,20)}..",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.itemDetails.length < 20 ? widget.itemDetails : "${widget.itemDetails.substring(0,20)}..",
                        style: const TextStyle(fontSize: 11,fontWeight: FontWeight.bold, color: Colors.black54),
                      ),
                      Text(
                        "\₹ ${widget.itemPrice}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),


                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
