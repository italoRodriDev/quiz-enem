import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crise/components/alert-dialog.component.dart';
import 'package:flutter_crise/components/snackbar.component.dart';
import 'package:get/get.dart';
import 'package:quiz_enem/models/assunto.model.dart';
import 'package:quiz_enem/models/materia.model.dart';

class CadastroAssuntoController extends GetxController {
  late BuildContext context;
  final firestore = FirebaseFirestore.instance;

  TextEditingController idMateria = TextEditingController();
  TextEditingController materia = TextEditingController();
  TextEditingController assunto = TextEditingController();

  ValueNotifier<List<dynamic>> listPumpEvent = ValueNotifier<List<dynamic>>([]);
  bool isLoading = false;

  Stream<List<MateriaModel>> getMaterias() {
    String idUser = FirebaseAuth.instance.currentUser!.uid;
    return firestore
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
    return firestore
        .collection('Materias')
        .doc(idUser.toString())
        .collection('Assuntos')
        .snapshots()
        .map((snapShot) => snapShot.docs
            .map((doc) => AssuntoModel.fromJson(doc.data()))
            .toList());
  }

  saveData() async {
    String idUser = FirebaseAuth.instance.currentUser!.uid;
    if (materia.text.isNotEmpty && materia.text != 'ND') {
      if (assunto.text.isNotEmpty) {
        var ref = await firestore
            .collection('Materias')
            .doc(idUser.toString())
            .collection('Assuntos')
            .doc();

        ref
            .set(AssuntoModel(
                    id: ref.id,
                    idMateria: idMateria.text,
                    materia: materia.text,
                    nome: assunto.text)
                .toJson())
            .then((value) async {
          resetData();
          await SnackbarComponent.show(context,
              text: 'Cadastrado com sucesso.');
        }).catchError((error) async {
          await SnackbarComponent.show(context, text: 'Erro ao salvar.');
        });
      } else {
        await SnackbarComponent.show(context,
            text: 'Digite o nome do assunto.');
      }
    } else {
      await SnackbarComponent.show(context, text: 'Selecione a matéria.');
    }
  }

  remove(AssuntoModel model, index) async {
    String idUser = FirebaseAuth.instance.currentUser!.uid;

    await AlertDialogComponent.show(context,
        titleText: 'Deseja excluir?',
        contentText: 'Assunto: ${model.nome.toString()}',
        confirmText: 'Excluir',
        cancelText: 'Cancelar',
        onPressedCancel: () {}, onPressedConfirm: () {
      setLoading(true);
      firestore
          .collection('Materias')
          .doc(idUser.toString())
          .collection('Assuntos')
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
    idMateria.clear();
    materia.clear();
    assunto.clear();
    update();
  }

  setLoading(value) {
    isLoading = value;
    update();
  }
}
