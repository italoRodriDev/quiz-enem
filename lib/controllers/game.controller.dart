import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

import '../models/pergunta.model.dart';
import '../services/step_perguntas.service.dart';

class GameController extends GetxController {
  ValueNotifier<String> respostaEvent = ValueNotifier<String>('ND');
  ValueNotifier<int> acertosEvent = ValueNotifier<int>(0);
  ValueNotifier<int> errosEvent = ValueNotifier<int>(0);
  int selectedValue = -1;
  bool respostaCorreta = false;

  @override
  void onReady() {
    acertosEvent.value = 0;
    errosEvent.value = 0;
    resetData();
    super.onReady();
  }

  resetData() {
    respostaEvent.value = 'ND';
    selectedValue = -1;
    respostaCorreta = false;
    Get.find<StepPerguntasService>().showBtnStep.value = false;
  }

  Stream<List<PerguntaModel>> getPerguntas() {
    return FirebaseFirestore.instance
        .collection('Usuarios')
        .doc('idUser')
        .collection('Perguntas')
        .snapshots()
        .map((snapShot) => snapShot.docs
            .map((doc) => PerguntaModel.fromJson(doc.data()))
            .toList());
  }

  setRespostaCorreta({required int value, required PerguntaModel item}) {
    selectedValue = value;
    respostaEvent.value = item.alternativas[value].toString();
    if (item.respostaCorreta == respostaEvent.value) {
      respostaCorreta = true;
      acertosEvent.value += 1;
    } else {
      respostaCorreta = false;
      errosEvent.value += 1;
    }
    Get.find<StepPerguntasService>().showBtnStep.value = true;
  }
}
