import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crise/components/select.component.dart';
import 'package:get/get.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

class CadastroPerguntasController extends GetxController {
  final firestore = FirebaseFirestore.instance;

  QuillEditorController quillCtrl = QuillEditorController();
  ValueNotifier<List<MenuItemData>> alternativasSelecionaveisEvent =
      ValueNotifier<List<MenuItemData>>([]);
  List<MenuItemData> alternativasSelecionaveis = [
    MenuItemData(label: "Alternativa 1", value: "1"),
    MenuItemData(label: "Alternativa 2", value: "2"),
    MenuItemData(label: "Alternativa 3", value: "3"),
    MenuItemData(label: "Alternativa 4", value: "4"),
    MenuItemData(label: "Alternativa 5", value: "5")
  ];
  List<MenuItemData> alternativas = [];
  var materia = 'ND';
  var assunto = 'ND';
  var respostaSelecionada = 'ND';

  setAlternativas() {
    if (alternativas.isEmpty) {
      for (var i in alternativasSelecionaveis) {
        alternativas.add(MenuItemData(
            label: 'Alternativa ${alternativasSelecionaveis.indexOf(i) + 1}',
            value: i.value));
        alternativasSelecionaveisEvent.value = alternativas;
      }
    }
  }

  addPergunta() {
    alternativas.clear();
    update();
    alternativasSelecionaveis
        .add(MenuItemData(label: 'Nova', value: Random.secure().nextDouble()));
    Future.delayed(const Duration(seconds: 3)).then((value) async {
      await setAlternativas();
      update();
    });
  }

  removerPergunta(item) {
    if (alternativasSelecionaveis.length > 1) {
      alternativas.clear();
      update();
      Future.delayed(const Duration(seconds: 3)).then((value) {
        var index = alternativasSelecionaveis.indexOf(item);
        alternativasSelecionaveis.removeAt(index);

        for (var i in alternativasSelecionaveis) {
          alternativas.add(MenuItemData(
              label: 'Alternativa ${alternativasSelecionaveis.indexOf(i) + 1}',
              value: i.value));
        }

        update();
      });
    }
  }

  setDataInput(item, textValue) {
    var index = alternativasSelecionaveis.indexOf(item);
    var data = alternativasSelecionaveis[index];
    alternativasSelecionaveis[index] =
        MenuItemData(label: data.label, value: textValue);
    update();
  }

  salvarPergunta() async {
    var textPergunta = await quillCtrl.getText();

    var ref = firestore
        .collection('Usuarios')
        .doc('idUser')
        .collection('Perguntas')
        .doc();

    List<String> list = [];

    for (var i in alternativasSelecionaveis) {
      list.add(i.value.toString());
    }

    var data = {
      "id": ref.id,
      "materia": materia,
      "assunto": assunto,
      "pergunta": textPergunta,
      "alternativas": list,
      "respostaSelecionada": respostaSelecionada
    };

    ref.set(data).then((value) {
      print('Salvo com sucesso');
    }).catchError((error) {
      print('Erro ao salvar');
    });
  }
}
