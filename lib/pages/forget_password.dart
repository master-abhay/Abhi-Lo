
import 'dart:ui';

import 'package:abhi_lo/Widgets/custom_button.dart';
import 'package:abhi_lo/constants.dart';
import 'package:abhi_lo/services/auth_Services.dart';
import 'package:abhi_lo/services/navigation_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  bool isLoading = false;
  String? email;

  late GlobalKey<FormState> _forgetPasswordFormKey;

  final GetIt _getIt = GetIt.instance;
  late NavigationServices _navigationServices;
  late AuthServices _authServices;

  @override
  void initState() {
    _navigationServices = _getIt.get<NavigationServices>();
    _authServices  = _getIt.get<AuthServices>();

    _forgetPasswordFormKey = GlobalKey<FormState>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.sizeOf(context).height * 0.03,horizontal: MediaQuery.sizeOf(context).width*0.06),

          child: SizedBox(
            width: double.infinity,
            child: Form(
                  key: _forgetPasswordFormKey,
                  child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            const Text(
            "Forget Password",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 23),),
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.sizeOf(context).width*0.04,vertical: MediaQuery.sizeOf(context).width*0.02),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding:  EdgeInsets.only(right: MediaQuery.sizeOf(context).width*0.04),
                          child: const Icon(Icons.person,size: 20,color: Colors.white,),
                        )
                        ,
                        Expanded(
                          child: TextFormField(validator: (value) {
                            if (value != null && EMAIL_VALIDATION_REGEX.hasMatch(value)) {
                              return null;
                            }
                            else{
                              return "Enter valid Email";
                            }
                          },
                            onSaved: (value){
                              setState(() {
                                email = value;
                              });
                            },
                            cursorColor: Colors.white,
                            textCapitalization: TextCapitalization.none,
                            style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w600),
                            decoration: const InputDecoration(
                                errorStyle: TextStyle(color: Colors.white)
                                ,border: InputBorder.none,
                              hintText: "Email",
                              hintStyle: TextStyle(color: Colors.white)
                            ),),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.sizeOf(context).height*0.02,),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width*0.5,
                    child: CustomButton(text: "Send Email", isLoading: isLoading,buttonColor: Colors.deepOrange, onPressed: () async{
                      if(_forgetPasswordFormKey.currentState!.validate()??false){
                        setState(() {
                          isLoading = true;
                        });
                        _forgetPasswordFormKey.currentState!.save();
                      print("printing email value in forget password...................................${email!.trim()}");
                       // await _authServices.forgotPassword(email: email!.trim());
                       await _authServices.forgotPassword(email: email!);


                        setState(() {
                          isLoading = false;
                        });
                      }
                    }),
                  )
                ],
              ),
               SizedBox(
                child: GestureDetector(
                    onTap: () {
                      _navigationServices.goBack();
                    },
                    child: const Text(
                      "<---Move Back to Login Page",
                      style:  TextStyle(color: Colors.white),
                    ))
              )

            ],
                  ),
                ),
          ),
        ));
  }
}
