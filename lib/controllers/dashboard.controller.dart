import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crise/components/alert-dialog.component.dart';
import 'package:flutter_crise/components/snackbar.component.dart';
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

  @override
  void onReady() {
    getPerguntas();
    super.onInit();
  }

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

  getPerguntas() {
    List<PerguntaModel> list = [];
    FirebaseFirestore.instance
        .collection('Usuarios')
        .doc('idUser')
        .collection('Perguntas')
        .snapshots()
        .map((snapShot) => snapShot.docs
            .map((doc) => PerguntaModel.fromJson(doc.data()))
            .toList())
        .forEach((element) {
      for (var i in element) {
        list.add(i);
      }
      perguntasEvent.value = list;
    });
  }

  getPerguntasFilter() {
    perguntasEvent.value.clear();
    List<PerguntaModel> list = [];
    var ref = FirebaseFirestore.instance
        .collection('Usuarios')
        .doc('idUser')
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
      for (var i in element) {
        list.add(i);
      }
      perguntasEvent.value = list;
    });
  }

  removePergunta(PerguntaModel item, int index) async {
    await AlertDialogComponent.show(context,
        titleText: 'Deseja excluir?',
        contentText: 'Pergunta ${index + 1}',
        confirmText: 'Excluir',
        cancelText: 'Cancelar',
        onPressedCancel: () {}, onPressedConfirm: () {
      FirebaseFirestore.instance
          .collection('Usuarios')
          .doc('idUser')
          .collection('Perguntas')
          .doc(item.id)
          .delete()
          .then((value) {
        SnackbarComponent.show(context, text: 'Excluido com sucesso');
      }).catchError((error) {
        SnackbarComponent.show(context, text: 'Erro ao excluir');
      });
    });
  }
}
