import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crise/components/snackbar.component.dart';
import 'package:get/get.dart';

import '../../core/colors.dart';
import '../../routes/app_routes.dart';

class SignUpController extends GetxController {
  late BuildContext context;

  final firebaseAuth = FirebaseAuth.instance;
  final firestoreRef = FirebaseFirestore.instance;

  TextEditingController email = TextEditingController();
  TextEditingController senha = TextEditingController();
  ValueNotifier<bool> isLoadingEvent = ValueNotifier<bool>(false);

  validForm() async {
    if (email.text.length > 8 && email.text.isEmail) {
      if (senha.text.length >= 6) {
        await signUp();
      } else {
        await SnackbarComponent.show(context,
            text: 'Digite sua senha.',
            backgroundColor: AppColor.primary,
            textColor: Colors.white);
      }
    } else {
      await SnackbarComponent.show(context,
          text: 'Digite seu e-mail.',
          backgroundColor: AppColor.primary,
          textColor: Colors.white);
    }
  }

  signUp() async {
    isLoadingEvent.value = true;
    firebaseAuth
        .createUserWithEmailAndPassword(email: email.text, password: senha.text)
        .then((result) async {
      isLoadingEvent.value = false;
      await saveDataUser(result);
    }).catchError((e) async {
      isLoadingEvent.value = false;
      await getError(e);
    });
  }

  saveDataUser(result) {
    String idUser = result.user!.uid.toString();

    var data = {
      "id": idUser,
      "email": email.text,
      "senha": senha.text,
    };

    firestoreRef.collection("Usuarios").doc(idUser).set(data).then((data) async {
      isLoadingEvent.value = false;
      Get.toNamed(Routes.DASH_BOARD);
    }).catchError((e) {
      isLoadingEvent.value = false;
    });
  }

  resetForm() {
    email.clear();
    senha.clear();
    isLoadingEvent.value = false;
  }

  getError(e) async {
    String message = 'Algo saiu errado.';
    if (e.code == "user-not-found") {
      message = 'Usuário não encontrado.';
    } else if (e.code == "wrong-password") {
      message = 'Senha Incorreta.';
    } else if (e.code == "unknown") {
      message = 'Informe Dados Válidos.';
    } else if (e.code == "invalid-email") {
      message = 'E-mail Inválido.';
    } else if (e.code == 'weak-password') {
      message = 'A senha fornecida é fraca.';
    } else if (e.code == 'email-already-in-use') {
      message = 'Usuário já registrado.';
    } else if (e.code == 'invalid-credential') {
      message = 'E-mail ou senha incorreto.';
    }
    await SnackbarComponent.show(context,
        text: message,
        backgroundColor: AppColor.primary,
        textColor: Colors.white);
  }
}
