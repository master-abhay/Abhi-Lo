import 'package:abhi_lo/models/user_profile.dart';
import 'package:abhi_lo/services/database_services.dart';
import 'package:abhi_lo/services/shared_prefrences.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../Widgets/bottom_navigation_bar.dart';
import '../Widgets/custom_button.dart';
import '../Widgets/custom_form_field.dart';
import '../constants.dart';
import '../services/alert_services.dart';
import '../services/auth_Services.dart';
import '../services/navigation_services.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;
  String? name, email, password;

  late GlobalKey<FormState> _registerFormKey;
  final GetIt _getIt = GetIt.instance;
  late NavigationServices _navigationServices;
  late AlertServices _alertServices;
  late AuthServices _authServices;
  late DatabaseServices _databaseServices;
  late LocalDataSaver _localDataSaver;

  @override
  void initState() {
    _navigationServices = _getIt.get<NavigationServices>();
    _alertServices = _getIt.get<AlertServices>();
    _authServices = _getIt.get<AuthServices>();
    _databaseServices = _getIt.get<DatabaseServices>();
    _localDataSaver = _getIt.get<LocalDataSaver>();

    _registerFormKey = GlobalKey<FormState>();
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
                      key: _registerFormKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Sign Up",
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
                                hintText: "Name",
                                height: 70,
                                obsecureText: false,
                                textCapitalization: TextCapitalization.words,
                                onSaved: (value) {
                                  setState(() {
                                    name = value;
                                  });
                                },
                                validateRegExp: NAME_VALIDATION_REGEX,
                              ),
                            ),
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
                                validateRegExp: EMAIL_VALIDATION_REGEX,
                                onSaved: (value) {
                                  setState(() {
                                    email = value?.toLowerCase();
                                  });
                                },
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
                                validateRegExp: PASSWORD_VALIDATION_REGEX,
                                onSaved: (value) {
                                  setState(() {
                                    password = value;
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                              width: MediaQuery.sizeOf(context).width * 0.5,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CustomButton(
                                    text: "Register",
                                    isLoading: isLoading,
                                    buttonColor: Colors.deepOrange,
                                    onPressed: () async {
                                      if (_registerFormKey.currentState!
                                              .validate() ??
                                          false) {
                                        setState(() {
                                          isLoading = true;
                                        });

                                        _registerFormKey.currentState!.save();

                                        final result =
                                            await _authServices.signUp(
                                                email: email!,
                                                password: password!);
                                        print(
                                            "printint result that the user created or not................................... ${result}");

                                        if (result) {
                                          try {
                                            await _databaseServices.setUpUser(
                                                UserProfile(
                                                    name: name,
                                                    uid: _authServices.user!.uid
                                                        .toString(),
                                                    wallet: 0,
                                                    email: _authServices
                                                        .user!.email
                                                        .toString()));

                                            try {
                                              await _localDataSaver
                                                  .saveName(name);
                                              await _localDataSaver
                                                  .saveEmail(email);

                                              await _localDataSaver
                                                  .saveWalletAmount(0);

                                              print("--------------->>>>>>>>>>>>Printing the value from the singup page of the uid of the user: ${_authServices.user!.uid.toString()}");

                                              await _localDataSaver.saveUID(
                                                  _authServices.user!.uid.toString());

                                              print(
                                                  "information saved to localDatabase successfully");
                                            } catch (e) {
                                              print(
                                                  "------------------->>>>>>>>>>>>>>>>>>> Error in Saving the information to LocalDatasaver");
                                            }
                                          } catch (e) {}
                                        }

                                        if (result) {
                                          _navigationServices.goBack();
                                          _navigationServices.push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      curvedBottomNavBar()));
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
                        const Text("Already Have Account! "),
                        GestureDetector(
                          onTap: () {
                            _navigationServices.goBack();
                          },
                          child: const Text(
                            "Login",
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
