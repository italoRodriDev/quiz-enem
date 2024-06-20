import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crise/components/alert-dialog-popup.component.dart';
import 'package:flutter_crise/components/select.component.dart';
import 'package:get/get.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
import 'package:quiz_enem/core/colors.dart';

class CadastroPerguntasController extends GetxController {
  late BuildContext context;
  final firestore = FirebaseFirestore.instance;

  QuillEditorController quillCtrl = QuillEditorController();
  ValueNotifier<List<MenuItemData>> alternativasSelecionaveisEvent =
      ValueNotifier<List<MenuItemData>>([]);
  List<MenuItemData> alternativasSelecionaveis = [
    MenuItemData(label: "Alternativa 1", value: "Letra A"),
    MenuItemData(label: "Alternativa 2", value: "Letra B"),
    MenuItemData(label: "Alternativa 3", value: "Letra C"),
    MenuItemData(label: "Alternativa 4", value: "Letra D"),
    MenuItemData(label: "Alternativa 5", value: "Letra E")
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
    Future.delayed(const Duration(seconds: 1)).then((value) async {
      await setAlternativas();
      update();
    });
  }

  removerPergunta(item) {
    if (alternativasSelecionaveis.length > 1) {
      alternativas.clear();
      update();
      Future.delayed(const Duration(seconds: 1)).then((value) {
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

    ref.set(data).then((value) async {
      print('Salvo com sucesso');
      await AlertDialogPopupsComponent.show(context,
          titleText: 'Salvo com sucesso',
          contentText: 'Fique a vontade para continuar',
          imageUrl: '',
          confirmText: 'Continuar',
          cancelText: 'Cancelar',
          colorPrimary: AppColor.primary,
          fontSizeTitle: 22,
          colorText: AppColor.textColor,
          onPressedConfirm: () {
            Get.back();
          });
    }).catchError((error) {
      print('Erro ao salvar');
    });
  }
}
