import 'package:abhi_lo/admin/admin_widgets/Admin_custom_form_field.dart';
import 'package:abhi_lo/services/alert_services.dart';
import 'package:abhi_lo/services/database_services.dart';
import 'package:abhi_lo/services/navigation_services.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../Widgets/custom_button.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {

  //for Button:
  bool isLoading = false;


  String? username, password;
  late GlobalKey<FormState> _adminLoginFormKey;
  late NavigationServices _navigationServices;

  late DatabaseServices _databaseServices;
  late AlertServices _alertServices;

  @override
  void initState() {
    final GetIt _getIt = GetIt.instance;
    _adminLoginFormKey = GlobalKey<FormState>();
    _navigationServices = _getIt.get<NavigationServices>();
    _databaseServices = _getIt.get<DatabaseServices>();
    _alertServices = _getIt.get<AlertServices>();


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xffededeb),
      body: buildUI(),
    );
  }

  Widget buildUI() {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: MediaQuery.of(context).size.height / 2),
          padding: const EdgeInsets.only(top: 45.0, left: 20.0, right: 20.0),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color.fromARGB(255, 53, 51, 51), Colors.black],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
              borderRadius: BorderRadius.vertical(
                  top: Radius.elliptical(
                      MediaQuery.of(context).size.width, 110.0))),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.sizeOf(context).height * 0.03,
              horizontal: MediaQuery.sizeOf(context).width * 0.03),
          child: Center(
              child: Form(
            key: _adminLoginFormKey,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.sizeOf(context).height * 0.08,
                      horizontal: MediaQuery.sizeOf(context).width * 0.01),
                  child: Column(
                    children: [
                      const Text(
                        "Let's Start with\nAdmin!",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontSize: 23),
                      ),
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.03,
                      ),
                      Material(
                        elevation: 10,
                        borderRadius: BorderRadius.circular(25),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.sizeOf(context).height * 0.08,
                              horizontal:
                                  MediaQuery.sizeOf(context).width * 0.05),
                          child: Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width * 0.7,
                                child: AdminCustomFormField(
                                  hintText: "Username",
                                  onSaved: (value) {
                                    setState(() {
                                      username = value;
                                    });
                                  },
                                  obscureText: false,
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.sizeOf(context).height * 0.03,
                              ),
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width * 0.7,
                                child: AdminCustomFormField(
                                  hintText: "Password",
                                  onSaved: (value) {
                                    password = value;
                                  },
                                  obscureText: true,
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.sizeOf(context).height * 0.03,
                              ),
                              SizedBox(
                                width: MediaQuery.sizeOf(context).width * 0.7,
                                child: CustomButton(
                                  text: 'Login ',
                                  isLoading: isLoading,
                                  onPressed: () async {


                                    if (_adminLoginFormKey.currentState!
                                            .validate() ??
                                        false) {

                                      setState(() {
                                        isLoading = true;

                                      });

                                      _adminLoginFormKey.currentState!.save();

                                      Map<String, dynamic> data =
                                          await _databaseServices.loginAdmin();

                                      print(data);

                                      if (username == data['username'] &&
                                          password == data["password"]) {
                                        print("Admin Verified");
                                        _alertServices.showToast(text: "Login Successful");

                                        _navigationServices.pushReplacement("/adminHome");

                                        setState(() {
                                          isLoading = false;

                                        });


                                      } else {
                                        print("Admin not Verified, Wrong Credentials");
                                        _alertServices.showToast(text: "You Entered Wrong Credentials");
                                        setState(() {
                                          isLoading = false;

                                        });

                                      }

                                    }
                                  },
                                  buttonColor: Colors.black,
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )),
        )
      ],
    );
  }
}
