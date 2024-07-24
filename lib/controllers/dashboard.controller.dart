import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crise/components/alert-dialog.component.dart';
import 'package:flutter_crise/components/snackbar.component.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:quiz_enem/models/pergunta.model.dart';

import '../models/assunto.model.dart';
import '../models/materia.model.dart';

class DashBoardController extends GetxController {
  late BuildContext context;
  final firestore = FirebaseFirestore.instance;
  ValueNotifier<List<PerguntaModel>> perguntasEvent =
      ValueNotifier<List<PerguntaModel>>([]);
  dynamic idMateria;
  dynamic idAssunto;
  ValueNotifier<String> materiaAtualEvent = ValueNotifier<String>('');
  ValueNotifier<String> assuntoAtualEvent = ValueNotifier<String>('');
  FlutterTts flutterTts = FlutterTts();
  bool enabledSpeak = false;

  Stream<List<MateriaModel>> getMaterias() {
    String idUser = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('Materias')
        .doc(idUser.toString())
        .collection('Materias')
        .snapshots()
        .map((snapShot) => snapShot.docs
            .map((doc) => MateriaModel.fromJson(doc.data()))
            .toList());
  }

  Stream<List<AssuntoModel>> getAssuntos() {
    String idUser = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance
        .collection('Materias')
        .doc(idUser.toString())
        .collection('Assuntos')
        .snapshots()
        .map((snapShot) => snapShot.docs
            .map((doc) => AssuntoModel.fromJson(doc.data()))
            .toList());
  }

  getPerguntasFilter() {
    String idUser = FirebaseAuth.instance.currentUser!.uid;
    var ref = FirebaseFirestore.instance
        .collection('Perguntas')
        .doc(idUser.toString())
        .collection('Perguntas');
    if (idMateria != null) {
      ref.where('idMateria', isEqualTo: idMateria);
    }

    if (idAssunto != null) {
      ref.where('idAssunto', isEqualTo: idAssunto);
    }

    ref
        .snapshots()
        .map((snapShot) => snapShot.docs
            .map((doc) => PerguntaModel.fromJson(doc.data()))
            .toList())
        .forEach((element) {
      List<PerguntaModel> list = [];
      for (var i in element) {
        list.add(i);
        perguntasEvent.value = list;
      }
    });
  }

  removePergunta(PerguntaModel item, int index) async {
    String idUser = FirebaseAuth.instance.currentUser!.uid;
    await AlertDialogComponent.show(context,
        titleText: 'Deseja excluir?',
        contentText: 'Pergunta ${index + 1}',
        confirmText: 'Excluir',
        cancelText: 'Cancelar',
        onPressedCancel: () {}, onPressedConfirm: () {
      firestore
          .collection('Perguntas')
          .doc(idUser.toString())
          .collection('Perguntas')
          .doc(item.id)
          .delete()
          .then((value) async {
        await SnackbarComponent.show(context, text: 'Excluido com sucesso');
      }).catchError((error) async {
        await SnackbarComponent.show(context, text: 'Erro ao excluir');
      });
    });
  }
}
