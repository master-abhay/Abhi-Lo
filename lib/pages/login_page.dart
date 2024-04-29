import 'package:abhi_lo/Widgets/custom_button.dart';
import 'package:abhi_lo/constants.dart';
import 'package:abhi_lo/models/user_profile.dart';
import 'package:abhi_lo/services/auth_Services.dart';
import 'package:abhi_lo/services/navigation_services.dart';
import 'package:abhi_lo/services/shared_prefrences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../Widgets/custom_form_field.dart';
import '../services/database_services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? email, password;

  bool isLoading = false;

  late GlobalKey<FormState> _loginFormKey;
  final GetIt _getIt = GetIt.instance;
  late NavigationServices _navigationServices;
  late AuthServices _authServices;
  late DatabaseServices _databaseServices;
  late LocalDataSaver _localDataSaver;

  @override
  void initState() {
    _navigationServices = _getIt.get<NavigationServices>();
    _authServices = _getIt.get<AuthServices>();
    _databaseServices = _getIt.get<DatabaseServices>();
    _localDataSaver = _getIt.get<LocalDataSaver>();

    _loginFormKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            color: Colors.deepOrange,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: MediaQuery.sizeOf(context).height * 0.6,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25))),
              ),
            ],
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            margin: EdgeInsets.only(
              left: MediaQuery.sizeOf(context).width * 0.05,
              right: MediaQuery.sizeOf(context).width * 0.05,
              top: MediaQuery.sizeOf(context).width * 0.06,
              bottom: MediaQuery.sizeOf(context).width * 0.01,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                    width: 200, child: Image.asset('images/Abhi_Lo_log.png')),
                // SizedBox(
                //   height: MediaQuery.sizeOf(context).height * 0.001,
                // ),
                Material(
                  elevation: 8,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Form(
                      key: _loginFormKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 27, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.03,
                          ),
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.8,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomFormField(
                                hintText: "Email",
                                height: 70,
                                obsecureText: false,
                                textCapitalization: TextCapitalization.none,
                                onSaved: (value) {
                                  setState(() {
                                    email = value!.toLowerCase();
                                  });
                                },
                                validateRegExp: EMAIL_VALIDATION_REGEX,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.8,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: CustomFormField(
                                hintText: "Password",
                                height: 70,
                                obsecureText: false,
                                textCapitalization: TextCapitalization.none,
                                onSaved: (value) {
                                  setState(() {
                                    password = value;
                                  });
                                },
                                validateRegExp: PASSWORD_VALIDATION_REGEX,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.8,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      _navigationServices
                                          .pushNamed("/adminLogin");
                                    },
                                    child: const Text("Admin Login")),
                                TextButton(
                                    onPressed: () {
                                      _navigationServices
                                          .pushNamed("/forgetPassword");
                                    },
                                    child: const Text("Forgot password?"))
                              ],
                            ),
                          ),
                          SizedBox(
                              width: MediaQuery.sizeOf(context).width * 0.5,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CustomButton(
                                    text: "Login",
                                    isLoading: isLoading,
                                    buttonColor: Colors.deepOrange,
                                    onPressed: () async {
                                      if (_loginFormKey.currentState!
                                              .validate() ??
                                          false) {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        _loginFormKey.currentState?.save();
                                        print(email);
                                        print(password);
                                        bool result = await _authServices.login(
                                            email!, password!);

                                        print(
                                            "printint result that the user logged in or not................................... ${result}");
                                        if (result) {
                                          User? user = _authServices.user;
                                          print(
                                              "-------------------->>>>>>>>>>>>>>>printing the user from login page: $user");

                                          UserProfile? userprofile =
                                              await _databaseServices
                                                  .getCurrentUser();

                                          await _databaseServices
                                              .setUpCartCollection(
                                                  userprofile!);
                                          print(
                                              "-------------------->>>>>>>>>>>>>>>printing the user from login page: $userprofile");

                                          //Saving information to the localDataSaver:
                                          try {
                                            print(
                                                "------------------------->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> inside the try block of the login page which is saving the information of the user to shared preferences");
                                            await _localDataSaver
                                                .saveName(userprofile.name);
                                            await _localDataSaver
                                                .saveEmail(userprofile.email);
                                            await _localDataSaver
                                                .saveWalletAmount(
                                                    userprofile.wallet);

                                            String? name =
                                                await _localDataSaver.getName();
                                            String? uid = await _localDataSaver
                                                .getEmail();
                                            int? walletAmount =
                                                await _localDataSaver
                                                    .getWalletAmount();
                                            print(name);
                                            print(uid);
                                            print(walletAmount);

                                            print(
                                                "information saved to localDatabase successfully");
                                          } catch (e) {
                                            print(
                                                "------------------->>>>>>>>>>>>>>>>>>> Error in Saving the information to LocalDatasaver");
                                          }

                                          _navigationServices.pushReplacement(
                                              "/curvedNavigationBar");
                                        }
                                        setState(() {
                                          isLoading = false;
                                        });
                                      }
                                    }),
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have account? "),
                        GestureDetector(
                          onTap: () {
                            _navigationServices.pushNamed('/signUp');
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    )
                  ],
                ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
