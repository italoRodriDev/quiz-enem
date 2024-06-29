import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crise/components/alert-dialog-popup.component.dart';
import 'package:flutter_crise/components/select.component.dart';
import 'package:flutter_crise/components/snackbar.component.dart';
import 'package:get/get.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
import 'package:quiz_enem/core/colors.dart';
import 'package:quiz_enem/models/pergunta.model.dart';

import '../models/assunto.model.dart';
import '../models/materia.model.dart';

class CadastroPerguntasController extends GetxController {
  late BuildContext context;
  final firestore = FirebaseFirestore.instance;

  QuillEditorController quillCtrl = QuillEditorController();
  ValueNotifier<List<MenuItemData>> alternativasSelecionaveisEvent =
      ValueNotifier<List<MenuItemData>>([]);
  ValueNotifier<bool> cadastroPerguntasEvent = ValueNotifier<bool>(true);
  ValueNotifier<String> respostaCorretaEvent = ValueNotifier<String>('ND');
  List<TextEditingController> inputsAlternativas = [
    TextEditingController(text: ''),
    TextEditingController(text: ''),
    TextEditingController(text: ''),
    TextEditingController(text: ''),
    TextEditingController(text: ''),
  ];
  TextEditingController idMateria = TextEditingController(text: 'ND');
  TextEditingController materia = TextEditingController();
  TextEditingController idAssunto = TextEditingController(text: 'ND');
  TextEditingController assunto = TextEditingController();
  MateriaModel materiaModel = MateriaModel(id: '', nome: '');
  AssuntoModel assutoModel = AssuntoModel(id: '', idMateria: '', materia: '', nome: '');

  Stream<List<MateriaModel>> getMaterias() {
    return FirebaseFirestore.instance
        .collection('Materias')
        .doc('idUser')
        .collection('Materias')
        .snapshots()
        .map((snapShot) => snapShot.docs
            .map((doc) => MateriaModel.fromJson(doc.data()))
            .toList());
  }

  Stream<List<AssuntoModel>> getAssuntos() {
    return FirebaseFirestore.instance
        .collection('Materias')
        .doc('idUser')
        .collection('Assuntos')
        .snapshots()
        .map((snapShot) => snapShot.docs
            .map((doc) => AssuntoModel.fromJson(doc.data()))
            .toList());
  }

  addPergunta() {
    if (inputsAlternativas.length < 5) {
      inputsAlternativas.add(TextEditingController());
      update();
    } else {
      SnackbarComponent.show(context,
          text: 'Cadastre no máximo 5 respostas.',
          backgroundColor: AppColor.warning,
          textColor: Colors.white);
    }
  }

  removerPergunta(item) {
    if (inputsAlternativas.length > 1) {
      var index = inputsAlternativas.indexOf(item);
      inputsAlternativas.removeAt(index);
      update();
    } else {
      SnackbarComponent.show(context,
          text: 'Cadastre no mínimo 1 resposta.',
          backgroundColor: AppColor.warning,
          textColor: Colors.white);
    }
  }

  setDataInput(item, textValue) async {
    var index = inputsAlternativas.indexOf(item);
    var data = inputsAlternativas[index];
    inputsAlternativas[index].text = textValue;
     inputsAlternativas[index].selection = TextSelection.fromPosition(
      TextPosition(offset:  inputsAlternativas[index].text.length),
    );
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

    for (var i in inputsAlternativas) {
      list.add(i.text.toString());
    }

    PerguntaModel data = PerguntaModel(
        id: ref.id,
        idMateria: idMateria.text,
        materia: materia.text,
        idAssunto: idAssunto.text,
        assunto: assunto.text,
        pergunta: textPergunta,
        alternativas: list,
        respostaCorreta: respostaCorretaEvent.value);

    ref.set(data.toJson()).then((value) async {
      await AlertDialogPopupsComponent.show(context,
          titleText: 'Salvo com sucesso',
          contentText: 'Fique a vontade para continuar',
          imageUrl: '',
          confirmText: 'Continuar',
          cancelText: 'Cancelar',
          colorPrimary: AppColor.primary,
          fontSizeTitle: 22,
          colorText: AppColor.textColor, onPressedConfirm: () {
        Get.back();
      });
    }).catchError((error) async {
      await SnackbarComponent.show(context, text: 'Error ao salvar');
    });
  }

  resetDataInputs() {
    for (var input in inputsAlternativas) {
      input.text = '';
    }
    update();
  }

  validarDataInputs() {
    List<bool> inputEmpty = [];
    for (var input in inputsAlternativas) {
       print(input.text);
      if (input.text.isNotEmpty) {
        inputEmpty.add(false);
      }
    }
   
    return inputEmpty.isNotEmpty ? false : true;
  }
}
