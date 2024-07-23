import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crise/components/button.component.dart';
import 'package:flutter_crise/components/checkbox.component.dart';
import 'package:flutter_crise/components/content.component.dart';
import 'package:flutter_crise/components/input-text.component.dart';
import 'package:flutter_crise/components/text.component.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:quiz_enem/controllers/auth/sign_up.controller.dart';
import 'package:quiz_enem/routes/app_routes.dart';

import '../../../../controllers/auth/sign_in.controller.dart';
import '../../../../core/colors.dart';

class CadastroPage extends GetView {
  SignUpController authCtrl = Get.put(SignUpController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    authCtrl.context = context;
    return GetBuilder<SignUpController>(
        init: authCtrl,
        builder: (_) {
          return Scaffold(
              body: SafeArea(
            child: SingleChildScrollView(
                child: ContentComponent(
                    content: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 300,
                                  child: TextComponent(
                                      value: 'Cadastre-se',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 33),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 300,
                                  child: TextComponent(
                                      value:
                                          'Faça seu cadastro para começar a utilizar o app.',
                                      color: AppColor.medium,
                                      fontSize: 18),
                                ),
                              ],
                            ),
                            const SizedBox(height: 50),
                            InputTextComponent(
                              textEditingController: authCtrl.email,
                              textInputType: TextInputType.emailAddress,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelText: 'E-mail',
                              hintText: 'Digite seu e-mail',
                            ),
                            const SizedBox(height: 45),
                            InputTextComponent(
                              textEditingController: authCtrl.senha,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              maxLength: 100,
                              obscureText: true,
                              labelText: 'Senha',
                              hintText: 'Crie uma senha',
                            ),
                            const SizedBox(height: 30),
                            ValueListenableBuilder(
                                valueListenable: authCtrl.isLoadingEvent,
                                builder: (context, bool value, child) {
                                  if (value == false) {
                                    return ButtonStylizedComponent(
                                        color: AppColor.button,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 100, vertical: 10),
                                        borderRadius: 0,
                                        onPressed: () {
                                          FocusScope.of(context).unfocus();
                                          authCtrl.validForm();
                                        },
                                        label: TextComponent(
                                            value: 'Continuar cadastro >',
                                            color: Colors.white));
                                  } else {
                                    return CircularProgressIndicator(
                                        color: AppColor.button);
                                  }
                                }),
                            const SizedBox(height: 50),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      Get.offAndToNamed(Routes.LOGIN);
                                    },
                                    child: Row(
                                      children: [
                                        TextComponent(
                                            value: 'Já possui uma conta? ',
                                            color: AppColor.textColor),
                                        TextComponent(
                                            value: 'Entrar',
                                            color: AppColor.button,
                                            decoration:
                                                TextDecoration.underline)
                                      ],
                                    ))
                              ],
                            ),
                            SvgPicture.asset(
                                'assets/images/undraw_video_games_x1tr.svg', height: 200,),
                          ],
                        )))),
          ));
        });
  }
}
