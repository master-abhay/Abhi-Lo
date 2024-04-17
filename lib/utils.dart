import 'package:abhi_lo/firebase_options.dart';
import 'package:abhi_lo/services/alert_services.dart';
import 'package:abhi_lo/services/auth_Services.dart';
import 'package:abhi_lo/services/database_services.dart';
import 'package:abhi_lo/services/media_services.dart';
import 'package:abhi_lo/services/navigation_services.dart';
import 'package:abhi_lo/services/shared_prefrences.dart';
import 'package:abhi_lo/services/storage_services.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

Future<void> setupFirebase() async {
  print("---------------->>>>>>>>>>>>>>>Setting Up Firebase");

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseAppCheck.instance.activate(
      // webRecaptchaSiteKey: 'recaptcha-v3-site-key',
      // Set androidProvider to `AndroidProvider.debug`
      androidProvider: AndroidProvider.debug,
      appleProvider: AppleProvider.debug);
  print("---------------->>>>>>>>>>>>>>>Completed Setting Up Firebase");
}

Future<void> registerServices() async {
  GetIt _getIt = GetIt.instance;

  print("---------------->>>>>>>>>>>>>>>registring services: <<<<<<<<<<<<<<<<<<<<<<<------------------");
  _getIt.registerSingleton<NavigationServices>(NavigationServices());
  print(
      "---------------->>>>>>>>>>>>>>>registring services: Navigation Services");

  _getIt.registerSingleton<AlertServices>(AlertServices());
  print("---------------->>>>>>>>>>>>>>>registring services: Alret Services");

  _getIt.registerSingleton<AuthServices>(AuthServices());
  print("---------------->>>>>>>>>>>>>>>registring services: AuthServices");

  _getIt.registerSingleton<DatabaseServices>(DatabaseServices());
  print("---------------->>>>>>>>>>>>>>>registring services: DatabaseServices");

  _getIt.registerSingleton<LocalDataSaver>(LocalDataSaver());
  print(
      "---------------->>>>>>>>>>>>>>>registring services: LocalDataSaverServices");

  _getIt.registerSingleton<MediaServices>(MediaServices());
  print("---------------->>>>>>>>>>>>>>>registring services: MediaServices");

  _getIt.registerSingleton<StorageServices>(StorageServices());
  print("---------------->>>>>>>>>>>>>>>registring services: StorageServices");

  // _getIt.registerSingleton<LocalDataSaver>(LocalDataSaver());
}

TextStyle boldTextStyle() {
  return const TextStyle(
      color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22);
}

TextStyle semiboldTextStyle() {
  return const TextStyle(
      color: Colors.black87, fontWeight: FontWeight.w500, fontSize: 18);
}

TextStyle midBoldTextStyle() {
  return const TextStyle(
      color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18);
}

TextStyle deliveryTime() {
  return const TextStyle(
      color: Colors.black87, fontWeight: FontWeight.w900, fontSize: 16);
}

TextStyle descriptionTextStyle() {
  return const TextStyle(
      color: Colors.black38, fontWeight: FontWeight.w500, fontSize: 14);
}

TextStyle fadeBoldTextStyle() {
  return const TextStyle(
      color: Colors.black54, fontWeight: FontWeight.w900, fontSize: 15);
}
