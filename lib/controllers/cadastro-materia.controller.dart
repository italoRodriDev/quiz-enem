import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crise/components/alert-dialog.component.dart';
import 'package:flutter_crise/components/snackbar.component.dart';
import 'package:get/get.dart';

import '../models/materia.model.dart';

class CadastroMateriaController extends GetxController {
  late BuildContext context;
  final firestore = FirebaseFirestore.instance;

  TextEditingController materia = TextEditingController();

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

  saveData() async {
    if (materia.text.isNotEmpty) {
      var ref = await firestore
          .collection('Materias')
          .doc('idUser')
          .collection('Materias')
          .doc();

      ref
          .set(MateriaModel(id: ref.id, nome: materia.text).toJson())
          .then((value) async {
        resetData();
        await SnackbarComponent.show(context, text: 'Cadastrado com sucesso.');
      }).catchError((error) async {
        await SnackbarComponent.show(context, text: 'Erro ao salvar.');
      });
    } else {
      await SnackbarComponent.show(context, text: 'Digite o nome da matéria.');
    }
  }

  remove(MateriaModel model, index) async {
    await AlertDialogComponent.show(context,
        titleText: 'Deseja excluir?',
        contentText: 'Matéria: ${model.nome.toString()}',
        confirmText: 'Excluir',
        cancelText: 'Cancelar',
        onPressedCancel: () {}, onPressedConfirm: () {
      FirebaseFirestore.instance
          .collection('Materias')
          .doc('idUser')
          .collection('Materias')
          .doc(model.id)
          .delete()
          .then((value) {
        SnackbarComponent.show(context, text: 'Excluido com sucesso');
      }).catchError((error) {
        SnackbarComponent.show(context, text: 'Erro ao excluir');
      });
    });
  }

  resetData() {
    materia.clear();
    update();
  }
}
