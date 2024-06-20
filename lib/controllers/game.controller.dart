import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

import '../models/pergunta.model.dart';
import '../services/step_perguntas.service.dart';

class GameController extends GetxController {
  QuillEditorController quillCtrl = QuillEditorController();
  ValueNotifier<String> respostaEvent = ValueNotifier<String>('ND');
  int selectedValue = -1;

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
    print(item.respostaSelecionada);
    print(respostaEvent.value);
  }
}
