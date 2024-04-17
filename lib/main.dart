import 'package:abhi_lo/services/auth_Services.dart';
import 'package:abhi_lo/services/navigation_services.dart';
import 'package:abhi_lo/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'firebase_options.dart';

Future<void> main() async {
  await setup();
  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: true);
  runApp(MyApp());
}

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISH_KEY']!;
  await Stripe.instance.applySettings();

  await setupFirebase();
  await registerServices();




}

class MyApp extends StatelessWidget {
  final GetIt _getIt = GetIt.instance;
  late NavigationServices _navigationServices;
  late AuthServices _authServices;
  MyApp({super.key}) {
    _navigationServices = _getIt.get<NavigationServices>();
    _authServices = _getIt.get<AuthServices>();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
          textTheme: GoogleFonts.poppinsTextTheme()),
      navigatorKey: _navigationServices.getNavigatorKey,
      routes: _navigationServices.routes,
      initialRoute:_authServices.user != null ? "/curvedNavigationBar" : "/onBoard",
      // initialRoute: "/adminHome",
      // initialRoute:_authServices.user != null ? "/adminHome" : "/onBoard",

    );
  }
}
