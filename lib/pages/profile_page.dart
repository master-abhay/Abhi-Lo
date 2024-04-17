import 'package:abhi_lo/Widgets/custom_button.dart';
import 'package:abhi_lo/models/user_profile.dart';
import 'package:abhi_lo/services/database_services.dart';
import 'package:abhi_lo/services/shared_prefrences.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../services/auth_Services.dart';
import '../services/navigation_services.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({super.key});

  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  final GetIt _getIt = GetIt.instance;
  late NavigationServices _navigationServices;
  late AuthServices _authServices;
  late LocalDataSaver _localDataSaver;
  late DatabaseServices _databaseServices;


  @override
  void initState() {
    _navigationServices = _getIt.get<NavigationServices>();
    _authServices = _getIt.get<AuthServices>();
    _databaseServices = _getIt.get<DatabaseServices>();
    _localDataSaver = _getIt.get<LocalDataSaver>();


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            IconButton(
              onPressed: () async {
                bool result = await _authServices.logOut();
                print(result);
                if (result) {
                  _navigationServices.pushReplacement("/login");
                }
              },
              icon: Icon(Icons.logout),
            ),
            CustomButton(
                text: "Firebase Test",
                isLoading: false,
                onPressed: () async {
                  // await _databaseServices.getCurrentUser();
                  String? name = await _localDataSaver.getName();
                  String? email = await _localDataSaver.getEmail();
                  int? walletAmount = await _localDataSaver.getWalletAmount();


                  print("------------------------------>>>>>>>>>>>>>>>>>>>>>>>>printing the name from the localDataSaver: $name");
                  print("------------------------------>>>>>>>>>>>>>>>>>>>>>>>>printing the name from the localDataSaver: $email");
                  print("------------------------------>>>>>>>>>>>>>>>>>>>>>>>>printing the name from the localDataSaver: $walletAmount");


                },
                buttonColor: Colors.purple),
            CustomButton(text: "Add Item", isLoading: false, onPressed: (){
              _navigationServices.pushNamed("/addFood");
            }, buttonColor: Colors.green)
          ],
        ),
      ),
    );
  }
}
