import 'package:abhi_lo/services/navigation_services.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../models/addItem_model.dart';
import '../utils.dart';

class FoodDetail extends StatefulWidget {
  final AddItem addItem;

  const FoodDetail({super.key, required this.addItem});

  @override
  State<FoodDetail> createState() => _FoodDetailState();
}

class _FoodDetailState extends State<FoodDetail> {
  int quantity = 1;

  final GetIt _getIt = GetIt.instance;
  late NavigationServices _navigationServices;

  @override
  void initState() {
    _navigationServices = _getIt.get<NavigationServices>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildUI(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      leading: IconButton(
        onPressed: () {
          _navigationServices.goBack();
        },
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.white,
        ),
      ),
      title: const Text(
        "Food Detail",
        style: TextStyle(color: Colors.white),
      ),
      elevation: 5.0,
      centerTitle: true,
    );
  }

  Widget _buildUI() {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
      child: Column(
        children: [
          _foodImage(),
          _foodDetails(),
          _deliveryTime(),
          _totalPriceAndAddToCart()
        ],
      ),
    ));
  }

  Widget _foodImage() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image.network(
            widget.addItem.imgUrl!,
            height: MediaQuery.sizeOf(context).width * 0.6,
            errorBuilder: (context, error, stackTrace) {
              // Return a custom error widget when image fails to load
              return Column(
                children: [
                  ClipRRect(
                    child: Image.asset(
                      "images/error_occured.png",
                      height: MediaQuery.sizeOf(context).width * 0.6,
                    ),
                  ),
                  const Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.red,
                      ),
                      // Text(error.toString().substring(0,20),style: TextStyle(color: Colors.red),),
                      Text(
                        "Failed to Load Image....",
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  )
                ],
              ); // You can replace this with any custom error widget
            },
          ),
        ),
      ],
    );
  }

  Widget _foodDetails() {
    return SizedBox(
      child: Column(
        children: [
          _foodNameAndQuantity(),
          _foodDescription(),
        ],
      ),
    );
  }

  Widget _foodNameAndQuantity() {
    return Padding(
      padding:
          const EdgeInsets.only(top: 8.0, right: 8.0, left: 8.0, bottom: 0.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(
              //   "Mediterranean",
              //   style: semiboldTextStyle(),
              // ),
              Text(
                widget.addItem.itemName!,
                style: boldTextStyle(),
              )
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              quantityButton(
                  icon: const Icon(
                    Icons.remove,
                    color: Colors.white,
                  ),
                  onTap: () {
                    if (quantity > 1) {
                      setState(() {
                        --quantity;
                      });
                    }
                  }),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  quantity.toString(),
                  style: boldTextStyle(),
                ),
              ),
              quantityButton(
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  onTap: () {
                    setState(() {
                      ++quantity;
                    });
                  })
            ],
          )
        ],
      ),
    );
  }

  Widget quantityButton({required Icon icon, required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Material(
          elevation: 5,
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
          child: icon),
    );
  }

  Widget _foodDescription() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
      child: Container(
        child: Text(
          widget.addItem.itemDetail!,
          style: descriptionTextStyle(),
        ),
      ),
    );
  }


  Widget _deliveryTime() {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Delivery Time",
            style: deliveryTime(),
          ),
          SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.05,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                Icons.alarm_outlined,
                color: Colors.black54,
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.01,
              ),
              Text(
                "30 min",
                style: deliveryTime(),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _totalPriceAndAddToCart() {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Total Price",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                "\$25",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              )
            ],
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {},
                child: Material(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          const Text(
                            "Add to cart",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.02,
                          ),
                          const Material(
                              color: Colors.green,
                              child: Icon(
                                Icons.shopping_cart_outlined,
                                color: Colors.white,
                              ))
                        ],
                      ),
                    )),
              )
            ],
          )
        ],
      ),
    );
  }
}
