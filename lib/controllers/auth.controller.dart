import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crise/components/alert-dialog-popup.component.dart';
import 'package:flutter_crise/components/snackbar.component.dart';
import 'package:get/get.dart';

import '../models/usuario.model.dart';
import '../routes/app_routes.dart';

class AuthController extends GetxController {
  late BuildContext context;
  var isLogin = false;
  var persistenceLogin = Persistence.LOCAL;

  final firebaseAuth = FirebaseAuth.instance;
  final firestoreRef = FirebaseFirestore.instance;

  final textEditIdTecnico = TextEditingController();
  final textEditEmail = TextEditingController();

  ValueNotifier<bool> isLoadingEvent = ValueNotifier<bool>(false);
  bool primeiroAcesso = false;

  checkIfLogin() async {
    firebaseAuth.authStateChanges().listen(
      (User? user) {
        if (user != null) {
          navigationToHome();
        } else {
          Get.toNamed(Routes.LOGIN);
        }
      },
    );
  }

  signIn({required String textEmail, required String textPassword}) async {
    firebaseAuth
        .signInWithEmailAndPassword(email: textEmail, password: textPassword)
        .then((result) {
      isLoadingEvent.value = false;
      existDataUser(textEmail);
    }).catchError((e) async {
      await validateCompleteRegister(email: textEmail);
      await getError(e);
    });
  }

  navigationToHome() async {
    final user = firebaseAuth.currentUser;
    if (user != null) {
      if (user.emailVerified) {
        await Get.toNamed(Routes.TABS_MENU);
      } else {
        await AlertDialogPopupsComponent.show(context,
            titleText: 'Verifique seu e-mail',
            contentText:
                'Enviamos um link de ativação para seu e-mail ${user.email}!',
            imageUrl: 'assets/undraw_mindfulness_8gqa.svg',
            confirmText: 'Confirmar',
            cancelText: 'Voltar');
      }
    }
  }

  signUp({required String textPassword}) async {
    if (textEditEmail.text.isNotEmpty) {
      isLoadingEvent.value = true;
      firebaseAuth
          .createUserWithEmailAndPassword(
              email: textEditEmail.text, password: textPassword)
          .then((result) async {
        isLoadingEvent.value = false;
        String idUser = result.user!.uid.toString();
        firestoreRef.collection("Tecnicos").doc(textEditIdTecnico.text).update({
          "idUser": idUser,
          "typeUser": "TECNICO",
          "dataCadastro": DateTime.now(),
          "perfilCompleto": true
        }).then((data) async {
          isLoadingEvent.value = false;
          await checkAndSendVerificationEmail(result.user!.email.toString());
        });
      }).catchError((e) async {
        await getError(e);
      });
    }
  }

  validateCompleteRegister({required String email}) async {
    firestoreRef
        .collection('Tecnicos')
        .where('email', isEqualTo: email.toString())
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty) {
        UsuarioModel userData = UsuarioModel.fromJson(value.docs.first.data());
        if (userData.perfilCompleto == false) {
          primeiroAcesso = true;
          if (userData.status == true) {
            isLoadingEvent.value = false;
            textEditEmail.text = email.toString();
            textEditIdTecnico.text = userData.id.toString();

            Get.toNamed(Routes.CADASTRO);
          } else {
            await SnackbarComponent.show(context,
                text: 'Seu acesso foi bloqueado!');
          }
        }
      } else {
        await SnackbarComponent.show(context, text: 'Usuário não encontrado!');
      }
    });
  }

  existDataUser(email) {
    firestoreRef
        .collection('Tecnicos')
        .where('email', isEqualTo: email.toString())
        .get()
        .then((value) async {
      if (value.docs.isEmpty) {
        await AlertDialogPopupsComponent.show(context,
            titleText: 'Sua conta foi deletada.',
            contentText: 'O adminitrador deletou sua conta.',
            imageUrl: 'assets/undraw_mindfulness_8gqa.svg',
            confirmText: 'Continuar',
            cancelText: 'Cancelar');
        firebaseAuth.currentUser!.delete();
      } else {
        navigationToHome();
      }
    });
  }

  resetPassword({required String textEmail}) async {
    isLoadingEvent.value = true;
    firebaseAuth.sendPasswordResetEmail(email: textEmail).then((value) async {
      isLoadingEvent.value = false;
      await AlertDialogPopupsComponent.show(context,
          titleText: 'Verifique seu e-mail',
          contentText: 'Enviamos um e-mail de recuperação de senha!',
          imageUrl: 'assets/undraw_mindfulness_8gqa.svg',
          confirmText: 'Confirmar',
          cancelText: 'Voltar');
      Get.back();
    }).catchError((e) async {
      await getError(e);
    });
  }

  checkAndSendVerificationEmail(textEmail) {
    final user = firebaseAuth.currentUser;
    if (user != null && !user.emailVerified) {
      user.sendEmailVerification().then((_) async {
        Get.offAndToNamed(Routes.LOGIN);
      }).catchError((e) async {
        await getError(e);
      });
    }
  }

  signOut() {
    FirebaseAuth.instance.signOut().then((value) {
      Get.offAndToNamed(Routes.SPLASH);
    });
  }

  getError(e) async {
    if (e.code == "user-not-found") {
      await SnackbarComponent.show(context, text: 'Usuário não encontrado!');
    } else if (e.code == "wrong-password") {
      await SnackbarComponent.show(context, text: 'Senha Incorreta!');
    } else if (e.code == "unknown") {
      await SnackbarComponent.show(context, text: 'Informe Dados Válidos!');
    } else if (e.code == "invalid-email") {
      await SnackbarComponent.show(context, text: 'E-mail Inválido!');
    } else if (e.code == 'weak-password') {
      await SnackbarComponent.show(context, text: 'A senha fornecida é fraca!');
    } else if (e.code == 'email-already-in-use') {
      await SnackbarComponent.show(context, text: 'Usuário já registrado!');
    } else if (e.code == 'invalid-credential') {
      if (primeiroAcesso = true) {
        await SnackbarComponent.show(context,
            text: 'E-mail ou senha incorreto!');
      } else {
        await SnackbarComponent.show(context, text: 'Crie sua senha!');
      }
    }
  }
}
