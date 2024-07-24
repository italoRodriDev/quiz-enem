import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crise/components/button.component.dart';
import 'package:flutter_crise/components/checkbox.component.dart';
import 'package:flutter_crise/components/content.component.dart';
import 'package:flutter_crise/components/input-text.component.dart';
import 'package:flutter_crise/components/text.component.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:quiz_enem/routes/app_routes.dart';

import '../../../../controllers/auth/sign_in.controller.dart';
import '../../../../core/colors.dart';

class LoginPage extends GetView {
  SignInController authCtrl = Get.put(SignInController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    authCtrl.context = context;
    authCtrl.checkIfLogin();
    return GetBuilder<SignInController>(
        init: authCtrl,
        builder: (_) {
          return WillPopScope(
              onWillPop: () async => false,
              child: Scaffold(
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
                                              value: 'Bloco de estudos',
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
                                                  'Crie um game quiz com os assuntos de estudo que desejar.',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 50),
                                    InputTextComponent(
                                      textEditingController: authCtrl.email,
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      textInputType: TextInputType.emailAddress,
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
                                      hintText: 'Digite a senha de 6 digitos',
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                CheckboxComponent(
                                                    initialValue:
                                                        _.persistenceLogin ==
                                                                Persistence
                                                                    .LOCAL
                                                            ? true
                                                            : false,
                                                    onChanged: (value) {
                                                      authCtrl
                                                          .setConnected(value);
                                                    }),
                                                const SizedBox(width: 5),
                                                SizedBox(
                                                    width: 160,
                                                    child: TextComponent(
                                                        value:
                                                            'Continuar conectado',
                                                        color:
                                                            AppColor.textColor))
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 30),
                                    ValueListenableBuilder(
                                        valueListenable:
                                            authCtrl.isLoadingEvent,
                                        builder: (context, bool value, child) {
                                          if (value == false) {
                                            return ButtonStylizedComponent(
                                                color: AppColor.button,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 100,
                                                        vertical: 10),
                                                borderRadius: 0,
                                                onPressed: () {
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                  authCtrl.validForm();
                                                },
                                                label: TextComponent(
                                                    value: 'Entrar >',
                                                    color: Colors.white));
                                          } else {
                                            return CircularProgressIndicator(
                                                color: AppColor.button);
                                          }
                                        }),
                                    const SizedBox(height: 20),
                                    TextButton(
                                        onPressed: () {
                                          authCtrl.sendEmailResetPassword();
                                        },
                                        child: SizedBox(
                                            width: 160,
                                            child: TextComponent(
                                                value: 'Esqueci minha senha',
                                                decoration:
                                                    TextDecoration.underline,
                                                color: AppColor.button))),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextButton(
                                            onPressed: () {
                                              Get.offAndToNamed(
                                                  Routes.CADASTRO);
                                            },
                                            child: Row(
                                              children: [
                                                TextComponent(
                                                    value:
                                                        'Ainda não possui uma conta? ',
                                                    color: AppColor.textColor),
                                                TextComponent(
                                                    value: 'cadastre-se',
                                                    color: AppColor.button,
                                                    decoration: TextDecoration
                                                        .underline)
                                              ],
                                            ))
                                      ],
                                    ),
                                    SvgPicture.asset(
                                        'assets/images/undraw_bookshelves_re_lxoy.svg',
                                        height: 200),
                                  ],
                                ))))),
              ));
        });
  }
}
