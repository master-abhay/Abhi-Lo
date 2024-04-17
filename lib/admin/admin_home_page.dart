import 'package:abhi_lo/services/navigation_services.dart';
import 'package:abhi_lo/utils.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {

  late NavigationServices _navigationServices;


  @override
  void initState() {
    GetIt _getIt = GetIt.instance;
    _navigationServices = _getIt.get<NavigationServices>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _buildUI(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text("Home Admin", style: boldTextStyle()),
      centerTitle: true,
    );
  }

  Widget _buildUI() {
    return GestureDetector(
      onTap: (){
_navigationServices.pushNamed("/addFood");
      },
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.sizeOf(context).height * 0.03,
            horizontal: MediaQuery.sizeOf(context).width * 0.04),
        child: SafeArea(
            child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
      flex: 3,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.sizeOf(context).height * 0.02,
                        horizontal: MediaQuery.sizeOf(context).width * 0.03),                  child: Image.asset(
                      "images/dummyImage.jpg",
                    ),
                  )),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.03,
              ),
             const Expanded(
                flex:4,
                  child: Text(
                    "Add Food Items",
                    style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
                  ))
            ],
          ),
        )),
      ),
    );
  }
}
