import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';

class IntroController extends GetxController {
  late BuildContext context;
  late RiveAnimationController btnAnimCtrl;

  @override
  void onInit() {
     btnAnimCtrl = OneShotAnimation('active',
     autoplay: false);
    super.onInit();
  }

}