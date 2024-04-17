import 'package:abhi_lo/Widgets/custom_button.dart';
import 'package:abhi_lo/services/navigation_services.dart';
import 'package:abhi_lo/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

import '../models/onborad_model.dart';

class OnBoard extends StatefulWidget {
  const OnBoard({super.key});

  @override
  State<OnBoard> createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  GetIt _getIt = GetIt.instance;
  late NavigationServices _navigationServices;

  int currentPage = 0;
  late PageController _pageController;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    _navigationServices = _getIt.get<NavigationServices>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return SafeArea(
        child: Column(
      children: [
        Expanded(
          child: PageView.builder(
              controller: _pageController,
              itemCount: onBoardContentsList.length,
              onPageChanged: (int index) {
                setState(() {
                  currentPage = index;
                });
                print("printing the current page in ......................................................................................${currentPage}");
              },
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(onBoardContentsList[i].image),
                      Column(
                        children: [
                          Text(onBoardContentsList[i].title,
                              style: midBoldTextStyle()),
                          SizedBox(height: MediaQuery.sizeOf(context).height*0.01,),
                          Text(
                            onBoardContentsList[i].description,
                            style: descriptionTextStyle(),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: List.generate(onBoardContentsList.length,
                            (index) => buildDots(index, context)),
                      ),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width*0.8,
                        child: CustomButton(
                            text: currentPage == onBoardContentsList.length - 1
                                ? "Start"
                                : "Next",
                            isLoading: false,
                            buttonColor: Colors.deepOrange,
                            onPressed: () {
                              if (currentPage == onBoardContentsList.length-1) {
                                print("in login page");
                                _navigationServices.pushReplacement("/login");
                              }
                              _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.fastOutSlowIn);
                            }),
                      )
                    ],
                  ),
                );
              }),
        )
      ],
    ));
  }

  Container buildDots(int index, BuildContext context) {
    return Container(
      height: 10.0,
      width: currentPage == index ? 18 : 7,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6), color: Colors.black38),
    );
  }
}
