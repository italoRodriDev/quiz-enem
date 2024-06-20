import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crise/components/alert-dialog-popup.component.dart';
import 'package:flutter_crise/components/alert-dialog.component.dart';
import 'package:flutter_crise/components/snackbar.component.dart';
import 'package:get/get.dart';
import 'package:quiz_enem/models/pergunta.model.dart';

class DashBoardController extends GetxController {
  late BuildContext context;
  final firestore = FirebaseFirestore.instance;

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

  removePergunta(PerguntaModel item, int index) async {
    await AlertDialogComponent.show(context,
        titleText: 'Deseja excluir?',
        contentText: 'Pergunta ${index + 1}',
        confirmText: 'Excluir',
        cancelText: 'Cancelar', onPressedCancel: () {
    }, onPressedConfirm: () {
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
