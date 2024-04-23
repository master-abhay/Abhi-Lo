import 'package:abhi_lo/admin/admin_login.dart';
import 'package:flutter/material.dart';

import '../Widgets/bottom_navigation_bar.dart';
import '../admin/add_food.dart';
import '../admin/admin_home_page.dart';
import '../pages/food_cart.dart';
import '../pages/food_detail.dart';
import '../pages/forget_password.dart';
import '../pages/home_page.dart';
import '../pages/login_page.dart';
import '../pages/onboard_page.dart';
import '../pages/signUp_page.dart';

class NavigationServices {
  late GlobalKey<NavigatorState> _navigationStateKey;

  NavigationServices() {
    _navigationStateKey = GlobalKey<NavigatorState>();
  }

  GlobalKey<NavigatorState> get getNavigatorKey {
    return _navigationStateKey;
  }

  Map<String, Widget Function(BuildContext)> _routes = {
    "/home": (context) => Home(),
    "/curvedNavigationBar": (context) => curvedBottomNavBar(),
    // "/foodDetail": (context) => FoodDetail(),
    "/login": (context) => LoginPage(),
    "/signUp": (context) => SignUp(),
    "/onBoard": (context) => OnBoard(),
    "/forgetPassword": (context) => ForgetPassword(),
    "/adminLogin": (context) => AdminLogin(),
    "/adminHome": (context) => AdminHomePage(),
    "/addFood": (context) => AddFood(),
    "/foodCart": (context) => FoodCart(),


  };

  Map<String, Widget Function(BuildContext)> get routes {
    return _routes;
  }

  void push(MaterialPageRoute route) {
    _navigationStateKey.currentState!.push(route);
  }

  void pushNamed(String route) {
    _navigationStateKey.currentState!.pushNamed(route);
  }

  void pushReplacement(String route) {
    _navigationStateKey.currentState!.pushReplacementNamed(route);
  }

  void goBack() {
    _navigationStateKey.currentState!.pop();
  }
}
