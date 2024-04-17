
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'navigation_services.dart';

class AlertServices {
  final GetIt _getIt = GetIt.instance;
  late NavigationServices _navigationServices;
  AlertServices() {
    _navigationServices = _getIt.get<NavigationServices>();
  }

  void showToast({required String text}) {
    try {
      DelightToastBar(
          autoDismiss: true,
          position: DelightSnackbarPosition.top,
          builder: (context) {
            return ToastCard(
              title: Text(text),
              color: Colors.white,
            );
          }).show(_navigationServices.getNavigatorKey.currentState!.context);
    } catch (e) {
      print(e);
    }
  }
}
