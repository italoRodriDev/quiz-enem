import 'package:batevolta/core/colors.dart';
import 'package:batevolta/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controllers/splash.controller.dart';

class SplashPage extends GetView<SplashController> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 5)).then((value) {
      Get.offAndToNamed(Routes.INTRO);
    });
    return Scaffold(
        backgroundColor: AppColor.primary,
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                    padding: EdgeInsets.only(top: 250),
                    child: Center(
                        child: Image.asset('assets/images/logo.png', width: 250))),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: CircularProgressIndicator(color: AppColor.light),
                ),
              ],
            ),
          ),
        ));
  }
}
