import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crise/components/alert-dialog-popup.component.dart';
import 'package:flutter_crise/components/alert-dialog.component.dart';
import 'package:flutter_crise/components/snackbar.component.dart';
import 'package:get/get.dart';

import '../../core/colors.dart';
import '../../models/usuario.model.dart';
import '../../routes/app_routes.dart';

class SignInController extends GetxController {
  late BuildContext context;

  var persistenceLogin = Persistence.SESSION;

  final firebaseAuth = FirebaseAuth.instance;
  final firestoreRef = FirebaseFirestore.instance;

  TextEditingController email = TextEditingController();
  TextEditingController senha = TextEditingController();
  ValueNotifier<bool> isLoadingEvent = ValueNotifier<bool>(false);

  setConnected(value) {
    if (value = true) {
      persistenceLogin = Persistence.LOCAL;
    } else {
      persistenceLogin = Persistence.SESSION;
    }
  }

  validForm() async {
    if (email.text.length > 8 && email.text.isEmail) {
      if (senha.text.length >= 6) {
        await signIn();
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

  checkIfLogin() async {
    firebaseAuth.authStateChanges().listen(
      (User? user) async {
        if (user != null) {
          await Get.toNamed(Routes.DASH_BOARD);
        } else {
          Get.toNamed(Routes.LOGIN);
        }
      },
    );
  }

  signIn() async {
    isLoadingEvent.value = true;
    firebaseAuth
        .signInWithEmailAndPassword(email: email.text, password: senha.text)
        .then((result) async {
      isLoadingEvent.value = false;
      await Get.toNamed(Routes.DASH_BOARD);
    }).catchError((e) async {
      isLoadingEvent.value = false;
      await getError(e);
    });
  }

  resetForm() {
    email.clear();
    senha.clear();
    isLoadingEvent.value = false;
    persistenceLogin = Persistence.SESSION;
  }

  sendEmailResetPassword() async {
    if (email.text.length > 8 && email.text.isEmail) {
      isLoadingEvent.value = true;
      firebaseAuth
          .sendPasswordResetEmail(email: email.text)
          .then((value) async {
        isLoadingEvent.value = false;
        await AlertDialogComponent.show(context,
            titleText: 'Verifique seu e-mail',
            contentText: 'Enviamos um e-mail de recuperação de senha.',
            confirmText: 'Continuar',
            cancelText: 'Cancelar');
      }).catchError((e) async {
        isLoadingEvent.value = false;
        await getError(e);
      });
    } else {
      await SnackbarComponent.show(context,
          text: 'Digite seu e-mail.',
          backgroundColor: AppColor.primary,
          textColor: Colors.white);
    }
  }

  signOut() {
    firebaseAuth.signOut().then((value) {
      Get.offAllNamed(Routes.LOGIN);
    });
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
