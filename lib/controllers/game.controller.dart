import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
import 'package:quiz_enem/controllers/dashboard.controller.dart';

import '../models/pergunta.model.dart';
import '../services/step_perguntas.service.dart';

class GameController extends GetxController {
  DashBoardController dashBoardCtrl = Get.put(DashBoardController());
  final firestore = FirebaseFirestore.instance;
  FlutterTts flutterTts = FlutterTts();
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
    flutterTts.setLanguage("pt-BR");
    flutterTts.stop();
    super.onReady();
  }

  resetData() {
    respostaEvent.value = 'ND';
    selectedValue = -1;
    respostaCorreta = false;
    flutterTts.stop();
    Get.find<StepPerguntasService>().showBtnStep.value = false;
  }

  Stream<List<PerguntaModel>> getPerguntas() {
    String idMateria = dashBoardCtrl.idMateria;
    String idAssunto = dashBoardCtrl.idAssunto;
    String idUser = FirebaseAuth.instance.currentUser!.uid;

    Query<Map<String, dynamic>> ref =
        firestore.collection('Usuarios').doc(idUser).collection('Perguntas');

    if (idMateria != null) {
      ref = ref.where('idMateria', isEqualTo: idMateria);
    }

    if (idAssunto != null) {
      ref = ref.where('idAssunto', isEqualTo: idAssunto);
    }

    // Use the stream and map it to the list of PerguntaModel
    return ref.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) =>
              PerguntaModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
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
    flutterTts.stop();
    Get.find<StepPerguntasService>().showBtnStep.value = true;
  }

  Future<void> speak(String pergunta) async {
    await flutterTts.speak(removeHtmlTagsTranslate(pergunta));
  }

  String removeHtmlTagsTranslate(String htmlText) {
    final RegExp exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return htmlText.replaceAll(exp, '');
  }
}
