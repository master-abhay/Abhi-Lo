import 'package:abhi_lo/models/addItem_model.dart';
import 'package:abhi_lo/pages/food_detail.dart';
import 'package:abhi_lo/services/database_services.dart';
import 'package:abhi_lo/services/navigation_services.dart';
import 'package:abhi_lo/services/shared_prefrences.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../Widgets/food_option.dart';
import '../Widgets/horizontal_scroll_bar.dart';
import '../Widgets/vertical_scroll_bar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool veg = false;
  bool nonVeg = false;
  bool chinese = false;
  bool sweets = false;

  List<String> streamCategoryList = [
    "_itemBurgerCollectionReference",
    "_itemIceCreamCollectionReference",
    "_itemNoodlesCollectionReference",
    "_itemPizzaCollectionReference",
  ];

  late String selectedItemCategory;

  GetIt _getIt = GetIt.instance;
  late NavigationServices _navigationServices;
  late DatabaseServices _databaseServices;
  late LocalDataSaver _localDataSaver;

  @override
  void initState() {
    selectedItemCategory = streamCategoryList[0];
    _navigationServices = _getIt.get<NavigationServices>();
    _databaseServices = _getIt.get<DatabaseServices>();
    _localDataSaver = _getIt.get<LocalDataSaver>();
    _getLocalDataFromSharepreferences();
    setState(() {
      veg = true;
    });
    super.initState();
  }

  String? username;

  _getLocalDataFromSharepreferences() async {
    final _username = await _localDataSaver.getName();

    setState(() {
      username = _username;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _builUI(),
    );
  }

  Widget _builUI() {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _headerText(),
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              "Delicious food",
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Text(
              "Discover and Get Great Food",
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                  fontWeight: FontWeight.bold),
            ),
          ),
          _foodOptions(),
          _viewFoodItemsHorizontally(),
          _viewFoodItemsVertically(),
        ],
      ),
    ));
  }

  Widget _headerText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Hi $username",
          style: const TextStyle(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.bold), // Handle null case
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(10.0)),
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.sizeOf(context).height * 0.005,
              horizontal: MediaQuery.sizeOf(context).width * 0.01),
          child: GestureDetector(
            onTap: () {
              _navigationServices.pushNamed("/foodCart");
            },
            child: const Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }

  Widget _foodOptions() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FoodOption(
          foodType: "Veg",
          imageName: veg ? "veg-food.json" : "veg-food_notSelected.json",
          onTap: () {
            veg = true;
            nonVeg = false;
            chinese = false;
            sweets = false;
            setState(() {
              selectedItemCategory = streamCategoryList[0];
            });
            print("Burger");
          },
          color: veg ? Colors.green.withOpacity(0.5) : Colors.white,
        ),
        FoodOption(
          foodType: "Non-Veg",
          imageName: nonVeg ? "non-veg-food.json" : "non-veg-food_notSelected.json",
          onTap: () {
            veg = false;
            nonVeg = true;
            chinese = false;
            sweets = false;
            setState(() {
              selectedItemCategory = streamCategoryList[1];
            });
            print("nonVeg");
          },
          color: nonVeg ? Colors.orange.withOpacity(0.4) : Colors.white,
        ),
        FoodOption(
          foodType: "Chinese",
          imageName: chinese ? "chinese-food.json" : "chinese-food_notSelected.json",
          onTap: () {
            veg = false;
            nonVeg = false;
            chinese = true;
            sweets = false;
            setState(() {
              selectedItemCategory = streamCategoryList[2];
            });
            print("chinese");
          },
          color: chinese ? Colors.yellow.withOpacity(0.5) : Colors.white,
        ),
        FoodOption(
          foodType: "Sweets",
          imageName: sweets ? "sweets-food.json" : "sweets-food_notSelected.json",

          onTap: () {
            veg = false;
            nonVeg = false;
            chinese = false;
            sweets = true;
            setState(() {
              selectedItemCategory = streamCategoryList[3];
            });
            print("sweets");
          },
          color: sweets ? Colors.red.withOpacity(0.4) : Colors.white,
        ),
      ],
    );
  }

  Widget _viewFoodItemsHorizontally() {
    return Container(
      // color: Colors.red,
      height: MediaQuery.sizeOf(context).height * 0.3,
      // Set the height of the horizontal list
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.sizeOf(context).height * 0.01,
          horizontal: MediaQuery.sizeOf(context).width * 0.01),
      child: getStreamBuilder(
          itemCategory: selectedItemCategory, scrollDirection: "horizontal"),
    );
  }

  Widget _viewFoodItemsVertically() {
    return Expanded(
      child: getStreamBuilder(
          itemCategory: selectedItemCategory, scrollDirection: "vertical"),
    );
  }

  Widget getStreamBuilder(
      {required String itemCategory, required String scrollDirection}) {
    return StreamBuilder(
      stream: _databaseServices.getAllIceCreamDocuments(itemCategory),
      builder: (context, snapshots) {
        if (snapshots.connectionState == ConnectionState.waiting ||
            snapshots.connectionState == ConnectionState.none) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshots.hasError) {
          return const Center(child: Text("Unable to load data"));
        } else if (snapshots.hasData && snapshots.data != null) {
          print(snapshots.data);

          final docList = snapshots.data!.docs;

          if (scrollDirection == "vertical") {
            // Return vertical ListView.builder here
            if (scrollDirection == "vertical") {
              return ListView.builder(
                  // physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: docList.length,
                  itemBuilder: (context, index) {
                    final AddItem item = docList[index].data() as AddItem;
                    print(
                        "-------------------->>>>>>>>>>>>>>>>>>>>>>printing the item in ListView.builder: $item");
                    print(
                        "-------------------->>>>>>>>>>>>>>>>>>>>>>printing the itemImageUrl in ListView.builder: ${item.imgUrl}");
                    print(
                        "-------------------->>>>>>>>>>>>>>>>>>>>>>printing the itemName in ListView.builder: ${item.itemName}");

                    return ViewFoodItemsVertically(
                        onTap: () {
                          _navigationServices.push(MaterialPageRoute(
                              builder: (context) => FoodDetail(
                                    addItem: item,
                                  )));
                        },
                        itemName: item.itemName!,
                        itemDetails: item.itemDetail!,
                        itemPrice: item.itemPrice!,
                        itemImgUrl: item.imgUrl!);
                  });
            }
          }

          if (scrollDirection == "horizontal") {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: docList.length,
              itemBuilder: (context, index) {
                final AddItem item = docList[index].data() as AddItem;
                return ViewFoodItemsHorizontally(
                  onTap: () {
                    _navigationServices.push(MaterialPageRoute(
                        builder: (context) => FoodDetail(
                              addItem: item,
                            )));
                  },
                  itemName: item.itemName!,
                  itemDetails: item.itemDetail!,
                  itemPrice: item.itemPrice!,
                  itemImgUrl: item.imgUrl!,
                );
              },
            );
          }
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
