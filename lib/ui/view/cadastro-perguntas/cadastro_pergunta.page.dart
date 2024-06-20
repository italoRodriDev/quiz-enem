import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crise/components/button.component.dart';
import 'package:flutter_crise/components/content.component.dart';
import 'package:flutter_crise/components/input-text.component.dart';
import 'package:flutter_crise/components/select.component.dart';
import 'package:flutter_crise/components/text.component.dart';
import 'package:get/get.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
import 'package:quiz_enem/controllers/cadastro-perguntas.controller.dart';

import '../../../core/colors.dart';
import '../../../core/fonts/fonts.dart';
import 'widgets/editor.dart';

class CadastroPerguntaPage extends GetView {
  CadastroPerguntasController ctrl = Get.put(CadastroPerguntasController());

  @override
  Widget build(BuildContext context) {
    ctrl.setAlternativas();
    return GetBuilder(
        init: ctrl,
        builder: (_) {
          return Scaffold(
              backgroundColor: AppColor.background,
              appBar: AppBar(
                title: TextComponent(
                    value: 'Cadastrar',
                    fontFamily: AppFont.Moonget,
                    fontSize: 22),
              ),
              body: SafeArea(
                  child: ContentComponent(
                      content: SingleChildScrollView(
                          child: Form(
                              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextComponent(value: 'Suas perguntas', fontSize: 22),
                      ButtonStylizedComponent(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 1),
                          label: TextComponent(
                              value: 'Salvar',
                              fontFamily: AppFont.Moonget,
                              fontSize: 16),
                          onPressed: () {
                            ctrl.salvarPergunta();
                          })
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 200,
                        child: SelectComponent(
                          labelText: 'Matéria',
                          primaryColor: AppColor.primary,
                          initialValue: 'ND',
                          onChanged: (value) {
                            ctrl.materia = value.toString();
                          },
                          menuItemData: const [
                            MenuItemData(label: 'Todos', value: 'ND')
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: SelectComponent(
                          labelText: 'Assunto',
                          primaryColor: AppColor.primary,
                          initialValue: 'ND',
                          onChanged: (value) {
                            ctrl.assunto = value.toString();
                          },
                          menuItemData: const [
                            MenuItemData(label: 'Todos', value: 'ND')
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 10),
                  EditorTexto(controller: ctrl.quillCtrl),
                  const Divider(),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextComponent(
                          value: 'Cadastre as respostas', fontSize: 22),
                      ButtonIconCircularComponent(
                          iconData: CupertinoIcons.add,
                          fillColor: AppColor.success,
                          iconColor: AppColor.light,
                          onPressed: () {
                            ctrl.addPergunta();
                          })
                    ],
                  ),
                  const SizedBox(height: 10),
                  ValueListenableBuilder(
                      valueListenable: ctrl.alternativasSelecionaveisEvent,
                      builder: ((context, value, child) {
                        if (ctrl.alternativas.isNotEmpty) {
                          return SelectComponent(
                            labelText: 'Resposta correta',
                            primaryColor: AppColor.primary,
                            menuItemData: ctrl.alternativas,
                          );
                        } else {
                          return LinearProgressIndicator();
                        }
                      })),
                  const SizedBox(height: 30),
                  for (var i in ctrl.alternativasSelecionaveis)
                    Column(
                      children: [
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            SizedBox(
                                width: 370,
                                child: InputTextComponent(
                                    onChanged: (value) {
                                      ctrl.setDataInput(i, value);
                                    },
                                    hintText: 'Digite uma resposta...',
                                    labelText:
                                        'Alternativa ${ctrl.alternativasSelecionaveis.indexOf(i) + 1}')),
                            const SizedBox(width: 10),
                            ButtonIconCircularComponent(
                                iconData: CupertinoIcons.trash,
                                fillColor: AppColor.danger,
                                iconColor: AppColor.light,
                                onPressed: () {
                                  ctrl.removerPergunta(i);
                                })
                          ],
                        )
                      ],
                    ),
                ],
              ))))));
        });
  }
}
