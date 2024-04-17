import 'package:abhi_lo/pages/order_poge.dart';
import 'package:abhi_lo/pages/profile_page.dart';
import 'package:abhi_lo/pages/wallet_page.dart';
import 'package:flutter/material.dart';

import '../pages/home_page.dart';

import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';

class curvedBottomNavBar extends StatefulWidget {
  const curvedBottomNavBar({super.key});

  @override
  State<curvedBottomNavBar> createState() => _curvedBottomNavBarState();
}

class _curvedBottomNavBarState extends State<curvedBottomNavBar> {
  int currentTabIndex = 0;
  List<Widget> pages = [];
  late Widget currentPage;
  late Home homePage;
  late OrderPage orderPage;
  late WalletPage walletPage;
  late Profilepage profilepage;

  @override
  void initState() {
    homePage = Home();
    orderPage = OrderPage();
    walletPage = WalletPage();
    profilepage = Profilepage();

    pages = [homePage, orderPage, walletPage, profilepage];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 65,
        backgroundColor: Colors.white,
        color: Colors.black,
        animationDuration: Duration(milliseconds: 300),
        onTap: (int index){
          setState(() {
            currentTabIndex = index;
          });
        },
        items: const [CurvedNavigationBarItem(
            child: Icon(Icons.home_outlined,color: Colors.white,),
            label: 'Home',
            labelStyle: TextStyle(color: Colors.white,)
        ),
          CurvedNavigationBarItem(
              child: Icon(Icons.shopping_bag_outlined,color: Colors.white,),
              label: 'Orders',
              labelStyle: TextStyle(color: Colors.white,)
          ),
          CurvedNavigationBarItem(
              child: Icon(Icons.wallet_outlined,color: Colors.white,),
              label: 'Wallet',
              labelStyle: TextStyle(color: Colors.white,)
          ),
          CurvedNavigationBarItem(
              child: Icon(Icons.person_outline,color: Colors.white,),
              label: 'Profile',
              labelStyle: TextStyle(color: Colors.white,)
          ),],
      ),
      body: pages[currentTabIndex],
    );
  }
}
