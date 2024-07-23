import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crise/components/alert-dialog.component.dart';
import 'package:flutter_crise/components/snackbar.component.dart';
import 'package:get/get.dart';

import '../models/materia.model.dart';

class CadastroMateriaController extends GetxController {
  late BuildContext context;
  final firestore = FirebaseFirestore.instance;

  TextEditingController materia = TextEditingController();
  bool isLoading = false;

  Stream<List<MateriaModel>> getMaterias() {
    String idUser = FirebaseAuth.instance.currentUser!.uid;
    return firestore
        .collection('Materias')
        .doc(idUser)
        .collection('Materias')
        .snapshots()
        .map((snapShot) => snapShot.docs
            .map((doc) => MateriaModel.fromJson(doc.data()))
            .toList());
  }

  saveData() async {
    String idUser = FirebaseAuth.instance.currentUser!.uid;
    if (materia.text.isNotEmpty) {
      var ref = await firestore
          .collection('Materias')
          .doc(idUser.toString())
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
    String idUser = FirebaseAuth.instance.currentUser!.uid;
    await AlertDialogComponent.show(context,
        titleText: 'Deseja excluir?',
        contentText: 'Matéria: ${model.nome.toString()}',
        confirmText: 'Excluir',
        cancelText: 'Cancelar',
        onPressedCancel: () {}, onPressedConfirm: () {
      setLoading(true);
      firestore
          .collection('Materias')
          .doc(idUser.toString())
          .collection('Materias')
          .doc(model.id)
          .delete()
          .then((value) async {
        setLoading(false);
        await SnackbarComponent.show(context, text: 'Excluido com sucesso');
      }).catchError((error) async {
        setLoading(false);
        await SnackbarComponent.show(context, text: 'Erro ao excluir');
      });
    });
  }

  resetData() {
    materia.clear();
    update();
  }

  setLoading(value) {
    isLoading = value;
    update();
  }
}
