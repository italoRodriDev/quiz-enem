import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crise/components/alert-dialog.component.dart';
import 'package:flutter_crise/components/button.component.dart';
import 'package:flutter_crise/components/content.component.dart';
import 'package:flutter_crise/components/text.component.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
import 'package:quiz_enem/controllers/game.controller.dart';
import 'package:quiz_enem/core/fonts/fonts.dart';
import 'package:quiz_enem/routes/app_routes.dart';

import '../../../core/colors.dart';
import '../../../models/pergunta.model.dart';
import 'widgets/steps.dart';

class StepsPerguntasPage extends GetView {
  GameController ctrl = GameController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: ctrl,
        builder: (_) {
          return Scaffold(
              appBar: AppBar(
                backgroundColor: AppColor.primary,
                automaticallyImplyLeading: false,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ValueListenableBuilder(
                        valueListenable: ctrl.acertosEvent,
                        builder: (context, int value, child) {
                          return TextComponent(
                              value: 'Corretas: ${value.toString()}',
                              fontSize: 15,
                              fontFamily: AppFont.Moonget);
                        }),
                    ValueListenableBuilder(
                        valueListenable: ctrl.errosEvent,
                        builder: (context, int value, child) {
                          return TextComponent(
                              value: 'Incorretas: ${value.toString()}',
                              fontSize: 15,
                              fontFamily: AppFont.Moonget);
                        }),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ButtonIconCircularComponent(
                            iconData: Icons.close,
                            fillColor: AppColor.danger,
                            iconColor: Colors.white,
                            onPressed: () {
                              ctrl.resetData();
                              Get.offAndToNamed(Routes.DASH_BOARD);
                            }),
                      ],
                    )
                  ],
                ),
              ),
              body: SafeArea(
                  child: SizedBox(
                      height: 750,
                      child: StreamBuilder<List<PerguntaModel>>(
                        stream: ctrl.getPerguntas(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<PerguntaModel> list = snapshot.data!;
                            return list.isNotEmpty ? StepsPerguntas(
                              onSkip: (index) {
                                FocusScope.of(context).unfocus();
                                ctrl.saveCurrentIndex(pergunta: list[index], index: index);
                                ctrl.resetData();
                              },
                              onBack: (index) {
                                FocusScope.of(context).unfocus();
                                ctrl.saveCurrentIndex(pergunta: list[index], index: index);
                                ctrl.resetData();
                              },
                              onFinish: () {
                                FocusScope.of(context).unfocus();
                                ctrl.resetData();
                                Get.back();
                              },
                              initialPage: 0,
                              accentColor: AppColor.primary,
                              stepsPages: [
                                for (var item in list)
                                  buildStep(context, ctrl, list, item)
                              ],
                            ) : TextComponent(value: 'Nenhum dado para exibir.');
                          } else if (snapshot.hasError) {
                            return Container();
                          } else {
                            return Center(
                                child: Container(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: const CircularProgressIndicator()));
                          }
                        },
                      ))));
        });
  }

  buildStep(BuildContext context, GameController ctrl, List<PerguntaModel> list,
      PerguntaModel item) {
    QuillEditorController quillCtrl = QuillEditorController();
    return StepPageData(
        title: 'Questão ${list.indexOf(item) + 1}',
        contentPage: Padding(
            padding: const EdgeInsets.all(20),
            child: ValueListenableBuilder(
                valueListenable: ctrl.respostaEvent,
                builder: (context, String value, child) {
                  return Column(
                    children: [
                      const SizedBox(height: 50),
                      Row(
                        children: [
                          TextButton(
                              onPressed: () {
                                ctrl.speak(item.pergunta);
                              },
                              child: Row(
                                children: [
                                  TextComponent(
                                      value: 'Me faça essa pergunta',
                                      color: AppColor.primary),
                                  SizedBox(width: 5),
                                  Icon(CupertinoIcons
                                      .antenna_radiowaves_left_right)
                                ],
                              ))
                        ],
                      ),
                      SizedBox(
                          height: 130,
                          child: QuillHtmlEditor(
                            hintText: 'Pergunta',
                            controller: quillCtrl,
                            isEnabled: false,
                            ensureVisible: false,
                            minHeight: 130,
                            autoFocus: false,
                            hintTextAlign: TextAlign.start,
                            padding: const EdgeInsets.only(left: 10, top: 10),
                            hintTextPadding: const EdgeInsets.only(left: 20),
                            inputAction: InputAction.newline,
                            onEditingComplete: (s) => {},
                            loadingBuilder: (context) {
                              return Center(
                                  child: CircularProgressIndicator(
                                strokeWidth: 1,
                                color: AppColor.primary,
                              ));
                            },
                            onFocusChanged: (focus) {},
                            onTextChanged: (text) => {},
                            onEditorCreated: () {
                              quillCtrl.setText(item.pergunta);
                            },
                            onEditorResized: (height) => {},
                            onSelectionChanged: (sel) => {},
                          )),
                      const SizedBox(height: 10),
                      const Divider(),
                      ValueListenableBuilder(
                          valueListenable: ctrl.respostaEvent,
                          builder: (context, String value, child) {
                            if (value == 'ND') {
                              return SizedBox(
                                  height: 350,
                                  child: SingleChildScrollView(
                                      child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              TextComponent(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 22,
                                                  value: 'Alterantivas',
                                                  color: AppColor.primary),
                                              TextComponent(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  value:
                                                      'Selecione a alternativa correta'),
                                            ],
                                          )
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      for (var i = 0;
                                          i < item.alternativas.length;
                                          i++)
                                        RadioListTile<int>(
                                          activeColor: AppColor.success,
                                          title: TextComponent(
                                              value: item.alternativas[i]
                                                  .toString()),
                                          value: i,
                                          groupValue: ctrl.selectedValue,
                                          onChanged: (int? value) async {
                                            await AlertDialogComponent.show(
                                                context,
                                                titleText:
                                                    'Tem certeza da resposta?',
                                                contentText:
                                                    item.alternativas[value!],
                                                confirmText: 'Confirmar',
                                                cancelText: 'Voltar',
                                                onPressedConfirm: () {
                                              ctrl.setRespostaCorreta(
                                                  value: value, item: item);
                                            });
                                          },
                                        ),
                                    ],
                                  )));
                            } else {
                              return Column(
                                children: [
                                  const SizedBox(height: 50),
                                  ctrl.respostaCorreta == true
                                      ? Column(
                                          children: [
                                            TextComponent(
                                                value: 'Resposta correta',
                                                fontFamily: AppFont.Moonget,
                                                fontSize: 30,
                                                color: AppColor.success),
                                            const SizedBox(height: 20),
                                            TextComponent(
                                                value: 'Você ganhou 1 ponto',
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ],
                                        )
                                      : Column(
                                          children: [
                                            TextComponent(
                                                value: 'Resposta incorreta',
                                                fontFamily: AppFont.Moonget,
                                                fontSize: 30,
                                                color: AppColor.danger),
                                            const SizedBox(height: 10),
                                            TextComponent(
                                                value:
                                                    'A resposta correta seria: ',
                                                fontSize: 18),
                                            const SizedBox(height: 10),
                                            TextComponent(
                                                value: item.respostaCorreta,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ],
                                        )
                                ],
                              );
                            }
                          }),
                    ],
                  );
                })));
  }
}
