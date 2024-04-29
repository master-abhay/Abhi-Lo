import 'package:abhi_lo/Widgets/custom_button.dart';
import 'package:abhi_lo/models/user_profile.dart';
import 'package:abhi_lo/services/alert_services.dart';
import 'package:abhi_lo/services/auth_Services.dart';
import 'package:abhi_lo/services/database_services.dart';
import 'package:abhi_lo/services/navigation_services.dart';
import 'package:abhi_lo/services/shared_prefrences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../utils.dart';

class FoodCart extends StatefulWidget {
  const FoodCart({super.key});

  @override
  State<FoodCart> createState() => _FoodCartState();
}

class _FoodCartState extends State<FoodCart> {
  late LocalDataSaver _localDataSaver;
  late DatabaseServices _databaseServices;
  late NavigationServices _navigationServices;
  late AlertServices _alertServices;
  late AuthServices _authServices;
  String? uid;

// // old Version
  // Future<void> getLocalData() async {
  //   final _uid = await _localDataSaver.getUID() ?? _authServices.user!.uid;
  //   print(
  //       "-------------verifying that uid in getLocalData() captured or not: $_uid");
  //
  //   setState(() {
  //     uid = _uid!;
  //   });
  // }

  Future<void> getLocalData() async {
    String? _uid = await _localDataSaver.getUID();
    if (_uid == null && _authServices.user != null) {
      _uid = _authServices.user!.uid;
    }
    print(
        "-------------verifying that uid in getLocalData() captured or not: $_uid");

    setState(() {
      uid = _uid;
    });
  }

  int totalAmount = 0;

  @override
  void initState() {
    GetIt _getIt = GetIt.instance;
    _databaseServices = _getIt.get<DatabaseServices>();
    _localDataSaver = _getIt.get<LocalDataSaver>();
    _navigationServices = _getIt.get<NavigationServices>();
    _alertServices = _getIt.get<AlertServices>();
    _authServices = _getIt.get<AuthServices>();

    getLocalData();
    print(
        "-------------verifying that uid in initState() captured or not: $uid");

    Future.delayed(const Duration(seconds: 2)).then((value) {
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: (uid != null)
          ? buildUI()
          : const Center(
              child: CircularProgressIndicator()), // Perform null check on uid
    );
  }

  Widget buildUI() {
    return SafeArea(
        child: Column(
      children: [
        _headerText(),
        Expanded(child: _body()),
        _totalAmount(),
      ],
    ));
  }

  Widget _headerText() {
    return Material(
      elevation: 10,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.sizeOf(context).height * 0.015),
          child: Text(
            "Food Cart",
            style: boldTextStyle(),
          ),
        ),
      ),
    );
  }

  Widget _body() {
    return StreamBuilder(
        stream: _databaseServices.getCartData(uid!),
        builder: (context, snapshots) {
          print(snapshots.data);

          if (snapshots.connectionState == ConnectionState.waiting &&
              snapshots.connectionState == ConnectionState.none) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshots.hasError) {
            return const Center(
              child: Text("Something went Wrong"),
            );
          }

          if (snapshots.hasData && snapshots.data != null) {
            totalAmount = 0;
            final _snapshotsList = snapshots.data!.docs;
            print(_snapshotsList);

            return ListView.builder(
                itemCount: _snapshotsList.length,
                itemBuilder: (context, index) {
                  final cartItem = _snapshotsList[index].data();
                  print(cartItem);

                  print("priting the total amount from cart item----------------->>>>>>>>>>>>>>>>>>${cartItem.itemPrice}");


                    totalAmount = totalAmount +
                        (int.parse(_snapshotsList[index].data().itemPrice!) *
                            _snapshotsList[index].data().quantity!);


                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.04,
                        vertical: MediaQuery.of(context).size.height * 0.01),
                    child: Material(
                      elevation: 1,
                      borderRadius: BorderRadius.circular(10),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical:
                            MediaQuery.of(context).size.height * 0.008,
                            horizontal:
                            MediaQuery.of(context).size.width * 0.03),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical:
                                      MediaQuery.of(context).size.height *
                                          0.04,
                                      horizontal:
                                      MediaQuery.of(context).size.width *
                                          0.04),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text(cartItem.quantity.toString()),
                                ),
                                SizedBox(
                                  width:
                                  MediaQuery.sizeOf(context).width * 0.04,
                                ),
                                Material(
                                  elevation: 2,
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.grey,
                                  child: Container(
                                    height: MediaQuery.of(context).size.height*0.1,
                                    width: MediaQuery.of(context).size.width*0.25,
                                    decoration: BoxDecoration(
                                        color: Colors.orangeAccent,
                                        // border: Border.all(color: Colors.blueGrey),
                                        borderRadius:
                                        BorderRadius.circular(50)),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.network(
                                          cartItem.imageUrl!,
                                          fit: BoxFit.cover,
                                        )),
                                  ),
                                ),
                                SizedBox(
                                  width:
                                  MediaQuery.sizeOf(context).width * 0.04,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width / 4,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        cartItem.itemName!,
                                        style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                                      ),
                                      Text(

                                        "\₹ ${int.parse(cartItem.itemPrice!) * cartItem.quantity!}",
                                        style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 16),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                _quantityButton(
                                    icon: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      // size: 22,
                                    ),
                                    onTap: () async {
                                      await _databaseServices.updateItemCount(
                                          cartItem.itemName!, 1);
                                      setState(() {});
                                    }),
                                IconButton(
                                    onPressed: () async {
                                      // // original code:
                                      // await _databaseServices.deleteCartItem(
                                      //     uid!, cartItem.itemId!);

                                      await _databaseServices.deleteCartItem(
                                          uid!, cartItem.itemName!);
                                      setState(() {});
                                      _alertServices.showToast(
                                          text: "Item Removed from Cart");
                                    },
                                    icon: const Icon(Icons.delete_outline)),
                                _quantityButton(
                                    icon: const Icon(
                                      Icons.remove,
                                      color: Colors.white,
                                      // size: 22,
                                    ),
                                    onTap: () async {
                                      await _databaseServices.updateItemCount(
                                          cartItem.itemName!,
                                          cartItem.quantity! != 1 ? -1 : 0);

                                      setState(() {});
                                    }),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );

                });
          } else {
            return Container();
          }
        });
  }

  Widget _totalAmount() {
    return Container(
      color: CupertinoColors.black,
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * .04,
            vertical: MediaQuery.of(context).size.height * 0.01),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Total Amount",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "\₹ ${totalAmount.toString()}",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: CustomButton(
                    text: "Checkout",
                    isLoading: false,
                    onPressed: () async {
                      UserProfile? userProfile =
                          await _databaseServices.getCurrentUser();

                      int currentAmount = userProfile!.wallet;
                      print(
                          "------Current Wallet Amount ====== $currentAmount");

                      if (currentAmount < totalAmount) {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(
                                "Add enough money to wallet before proceeding..")));
                      } else {
                        await _databaseServices
                            .updateWalletBalance(-totalAmount);
                        await _databaseServices.deleteCartData(uid!);
                        _navigationServices.goBack();
                      }
                    },
                    buttonColor: Colors.green))
          ],
        ),
      ),
    );
  }

  Widget _quantityButton({required Icon icon, required Function() onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Material(
        elevation: 2,
        color: Colors.green,
        borderRadius: BorderRadius.circular(10),
        child: icon,
      ),
    );
  }
}
