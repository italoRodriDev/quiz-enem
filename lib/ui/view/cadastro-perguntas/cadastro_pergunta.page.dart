import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crise/components/button.component.dart';
import 'package:flutter_crise/components/content.component.dart';
import 'package:flutter_crise/components/input-text.component.dart';
import 'package:flutter_crise/components/select.component.dart';
import 'package:flutter_crise/components/text.component.dart';
import 'package:get/get.dart';
import 'package:quiz_enem/controllers/cadastro-perguntas.controller.dart';
import 'package:quiz_enem/routes/app_routes.dart';

import '../../../core/colors.dart';
import '../../../core/fonts/fonts.dart';
import '../../../models/assunto.model.dart';
import '../../../models/materia.model.dart';
import 'widgets/editor.dart';

class CadastroPerguntaPage extends GetView {
  CadastroPerguntasController ctrl = Get.put(CadastroPerguntasController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ctrl.context = context;
    return GetBuilder(
        init: ctrl,
        builder: (_) {
          return Scaffold(
              backgroundColor: AppColor.background,
              appBar: AppBar(
                title: TextComponent(
                    value: 'Cadastrar pergunta',
                    fontFamily: AppFont.Moonget,
                    fontSize: 22),
              ),
              body: SafeArea(
                  child: ContentComponent(
                      content: SingleChildScrollView(
                          child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextComponent(
                                          value: 'Sua pergunta', fontSize: 22),
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
                                  EditorTexto(controller: ctrl.quillCtrl),
                                  const SizedBox(height: 10),
                                  const Divider(),
                                  StreamBuilder<List<MateriaModel>>(
                                    stream: ctrl.getMaterias(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator(); // Show a loading indicator while waiting for data
                                      } else if (snapshot.hasError) {
                                        return Text(
                                            'Error: ${snapshot.error}'); // Show an error message if there's an error
                                      } else if (snapshot.hasData &&
                                          snapshot.data!.isNotEmpty) {
                                        List<MateriaModel> list =
                                            snapshot.data!;
                                        List<MenuItemData> listMenu = [];

                                        listMenu.add(MenuItemData(
                                            label: 'Nenhuma', value: 'ND'));

                                        for (var i in list) {
                                          listMenu.add(MenuItemData(
                                              label: i.nome, value: i.id));
                                        }

                                        return SelectComponent(
                                          initialValue: _.idMateria.text,
                                          labelText: 'Matéria',
                                          menuItemData: listMenu,
                                          primaryColor: AppColor.primary,
                                          onChanged: (value) {
                                            if (value != 'ND') {
                                              var index = list.indexWhere(
                                                  (element) =>
                                                      element.id == value);
                                              MateriaModel data = list[index];
                                              ctrl.idMateria.text = data.id;
                                              ctrl.materia.text = data.nome;
                                            }
                                          },
                                        );
                                      } else {
                                        return Container();
                                      }
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  StreamBuilder<List<AssuntoModel>>(
                                    stream: ctrl.getAssuntos(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return CircularProgressIndicator(); // Show a loading indicator while waiting for data
                                      } else if (snapshot.hasError) {
                                        return Text(
                                            'Error: ${snapshot.error}'); // Show an error message if there's an error
                                      } else if (snapshot.hasData &&
                                          snapshot.data!.isNotEmpty) {
                                        List<AssuntoModel> list =
                                            snapshot.data!;
                                        List<MenuItemData> listMenu = [];

                                        listMenu.add(MenuItemData(
                                            label: 'Nenhuma', value: 'ND'));

                                        for (var i in list) {
                                          listMenu.add(MenuItemData(
                                              label: i.nome, value: i.id));
                                        }

                                        return SelectComponent(
                                          initialValue: _.idAssunto.text,
                                          labelText: 'Assunto',
                                          menuItemData: listMenu,
                                          primaryColor: AppColor.primary,
                                          onChanged: (value) {
                                            if (value != 'ND') {
                                              var index = list.indexWhere(
                                                  (element) =>
                                                      element.id == value);
                                              AssuntoModel data = list[index];
                                              ctrl.idAssunto.text = data.id;
                                              ctrl.assunto.text = data.nome;
                                            }
                                          },
                                        );
                                      } else {
                                        return Container();
                                      }
                                    },
                                  ),
                                  const Divider(),
                                  const SizedBox(height: 30),
                                  ValueListenableBuilder(
                                      valueListenable:
                                          ctrl.cadastroPerguntasEvent,
                                      builder: ((context, bool value, child) {
                                        if (value == true) {
                                          return Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              TextComponent(
                                                  value:
                                                      'Cadastre as respostas',
                                                  fontSize: 22),
                                              ButtonIconCircularComponent(
                                                  iconData: CupertinoIcons.add,
                                                  fillColor: AppColor.success,
                                                  iconColor: AppColor.light,
                                                  onPressed: () {
                                                    FocusScope.of(context)
                                                        .unfocus();
                                                    ctrl.addPergunta();
                                                  })
                                            ],
                                          );
                                        } else {
                                          return Row(
                                            children: [
                                              ButtonIconCircularComponent(
                                                  iconData: Icons.arrow_back,
                                                  fillColor: AppColor.primary,
                                                  iconColor: AppColor.light,
                                                  onPressed: () {
                                                    ctrl.cadastroPerguntasEvent
                                                            .value =
                                                        !ctrl
                                                            .cadastroPerguntasEvent
                                                            .value;
                                                  }),
                                              const SizedBox(width: 5),
                                              TextComponent(
                                                  value:
                                                      'Escolha a resposta correta',
                                                  fontSize: 22),
                                            ],
                                          );
                                        }
                                      })),
                                  const SizedBox(height: 10),
                                  ValueListenableBuilder(
                                      valueListenable:
                                          ctrl.cadastroPerguntasEvent,
                                      builder: ((context, bool value, child) {
                                        if (value == true) {
                                          return Column(
                                            children: [
                                              const SizedBox(height: 30),
                                              for (var i
                                                  in ctrl.inputsAlternativas)
                                                Column(
                                                  children: [
                                                    const SizedBox(height: 20),
                                                    Row(
                                                      children: [
                                                        SizedBox(
                                                            width: 350,
                                                            child:
                                                                InputTextComponent(
                                                                    floatingLabelBehavior:
                                                                        FloatingLabelBehavior
                                                                            .always,
                                                                    textEditingController:
                                                                        i,
                                                                    onChanged:
                                                                        (value) {
                                                                      ctrl.setDataInput(
                                                                          i,
                                                                          i.text);
                                                                    },
                                                                    hintText:
                                                                        'Digite uma resposta...',
                                                                    labelText:
                                                                        'Alternativa ${ctrl.inputsAlternativas.indexOf(i) + 1}')),
                                                        const SizedBox(
                                                            width: 10),
                                                        ButtonIconCircularComponent(
                                                            iconData:
                                                                CupertinoIcons
                                                                    .trash,
                                                            fillColor:
                                                                AppColor.danger,
                                                            iconColor:
                                                                AppColor.light,
                                                            onPressed: () {
                                                              FocusScope.of(
                                                                      context)
                                                                  .unfocus();
                                                              ctrl.removerPergunta(
                                                                  i);
                                                            })
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              const SizedBox(height: 30),
                                              ButtonStylizedComponent(
                                                  label: TextComponent(
                                                      value:
                                                          'Continuar cadastro',
                                                      fontSize: 18,
                                                      fontFamily:
                                                          AppFont.Moonget),
                                                  onPressed: () {
                                                    if (ctrl.validarDataInputs() ==
                                                        false) {
                                                      ctrl.cadastroPerguntasEvent
                                                              .value =
                                                          !ctrl
                                                              .cadastroPerguntasEvent
                                                              .value;
                                                    }
                                                  }),
                                              const SizedBox(height: 50),
                                            ],
                                          );
                                        } else {
                                          return Column(
                                            children: [
                                              for (var i
                                                  in ctrl.inputsAlternativas)
                                                Column(
                                                  children: [
                                                    const SizedBox(height: 10),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        ValueListenableBuilder(
                                                            valueListenable: ctrl
                                                                .respostaCorretaEvent,
                                                            builder: ((context,
                                                                String opcao,
                                                                child) {
                                                              return ButtonIconCircularComponent(
                                                                  iconData: opcao ==
                                                                          i.text
                                                                      ? Icons
                                                                          .check
                                                                      : Icons
                                                                          .close,
                                                                  fillColor: opcao ==
                                                                          i.text
                                                                      ? AppColor
                                                                          .success
                                                                      : AppColor
                                                                          .danger,
                                                                  iconColor:
                                                                      AppColor
                                                                          .light,
                                                                  onPressed:
                                                                      () {
                                                                    ctrl.respostaCorretaEvent
                                                                            .value =
                                                                        i.text;
                                                                  });
                                                            })),
                                                        SizedBox(
                                                            child: Row(
                                                              children: [
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    TextComponent(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        value:
                                                                            'Alternativa ${ctrl.inputsAlternativas.indexOf(i) + 1}'),
                                                                    SizedBox(
                                                                        width:
                                                                            350,
                                                                        child: TextComponent(
                                                                            value: i.text.toString().length > 65
                                                                                ? '${i.text.toString().substring(0, 65)}...'
                                                                                : i.text.toString()))
                                                                  ],
                                                                )
                                                              ],
                                                            )),
                                                        
                                                      ],
                                                    ),
                                                    const Divider(),
                                                  ],
                                                ),
                                            ],
                                          );
                                        }
                                      })),
                                ],
                              ))))));
        });
  }
}
