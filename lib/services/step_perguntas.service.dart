import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StepPerguntasService extends GetxService {
  ValueNotifier<bool> showBtnStep = ValueNotifier<bool>(false);

  setShowBtnContinueSteps({required bool value}) {
    showBtnStep.value = value;
  }
}
