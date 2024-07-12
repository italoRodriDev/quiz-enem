import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crise/components/text.component.dart';
import 'package:flutter_crise/components/button.component.dart';
import 'package:flutter_crise/components/content.component.dart';
import 'package:flutter_crise/components/select.component.dart';
import 'package:get/get.dart';
import 'package:quiz_enem/controllers/dashboard.controller.dart';
import 'package:quiz_enem/core/colors.dart';
import 'package:quiz_enem/core/fonts/fonts.dart';
import 'package:quiz_enem/models/assunto.model.dart';
import 'package:quiz_enem/models/pergunta.model.dart';
import 'package:quiz_enem/routes/app_routes.dart';

import '../../../models/materia.model.dart';

class DashBoardPage extends GetView {
  DashBoardController ctrl = Get.put(DashBoardController());

  @override
  Widget build(BuildContext context) {
    ctrl.context = context;
    return GetBuilder(
        init: ctrl,
        builder: (_) {
          return Scaffold(
              backgroundColor: AppColor.background,
              appBar: AppBar(
                actions: [
                  Padding(
                      padding: const EdgeInsets.only(right: 20, top: 3),
                      child: ButtonIconCircularComponent(
                          iconData: Icons.play_arrow,
                          fillColor: AppColor.tertiary,
                          iconColor: Colors.white,
                          onPressed: () {
                            Get.toNamed(Routes.STEP_PERGUNTAS);
                          }))
                ],
                title: TextComponent(
                    value: 'Dashboard',
                    fontFamily: AppFont.Moonget,
                    fontSize: 22),
              ),
              body: SafeArea(
                  child: ContentComponent(
                      content: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextComponent(value: 'Suas perguntas', fontSize: 22),
                      ButtonStylizedComponent(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 1),
                          label: TextComponent(
                              value: 'Cadastrar nova',
                              fontFamily: AppFont.Moonget,
                              fontSize: 16),
                          onPressed: () {
                            Get.toNamed(Routes.CADASTRO_PERGUNTA);
                          })
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () {
                            Get.toNamed(Routes.CADASTRO_MATERIA);
                          },
                          child: TextComponent(value: 'Cadastrar matéria')),
                      TextButton(
                          onPressed: () {
                            Get.toNamed(Routes.CADASTRO_ASSUNTO);
                          },
                          child: TextComponent(value: 'Cadastrar assunto')),
                    ],
                  ),
                  const SizedBox(height: 10),
                  StreamBuilder<List<MateriaModel>>(
                    stream: ctrl.getMaterias(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(); // Show a loading indicator while waiting for data
                      } else if (snapshot.hasError) {
                        return Text(
                            'Error: ${snapshot.error}'); // Show an error message if there's an error
                      } else if (snapshot.hasData &&
                          snapshot.data!.isNotEmpty) {
                        List<MateriaModel> list = snapshot.data!;
                        List<MenuItemData> listMenu = [];

                        listMenu
                            .add(MenuItemData(label: 'Nenhuma', value: 'ND'));

                        for (var i in list) {
                          listMenu
                              .add(MenuItemData(label: i.nome, value: i.id));
                        }

                        return SelectComponent(
                          labelText: 'Matéria',
                          menuItemData: listMenu,
                          primaryColor: AppColor.primary,
                          onChanged: (value) {
                            if (value != 'ND') {
                              var index = list
                                  .indexWhere((element) => element.id == value);
                              MateriaModel data = list[index];
                              ctrl.idMateria = data.id;
                              ctrl.getPerguntasFilter();
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
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(); // Show a loading indicator while waiting for data
                      } else if (snapshot.hasError) {
                        return Text(
                            'Error: ${snapshot.error}'); // Show an error message if there's an error
                      } else if (snapshot.hasData &&
                          snapshot.data!.isNotEmpty) {
                        List<AssuntoModel> list = snapshot.data!;
                        List<MenuItemData> listMenu = [];

                        listMenu
                            .add(MenuItemData(label: 'Nenhuma', value: 'ND'));

                        for (var i in list) {
                          listMenu
                              .add(MenuItemData(label: i.nome, value: i.id));
                        }

                        return SelectComponent(
                          labelText: 'Assunto',
                          menuItemData: listMenu,
                          primaryColor: AppColor.primary,
                          onChanged: (value) {
                            if (value != 'ND') {
                              var index = list
                                  .indexWhere((element) => element.id == value);
                              AssuntoModel data = list[index];
                              ctrl.idAssunto = data.id;
                              ctrl.getPerguntasFilter();
                            }
                          },
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                  const SizedBox(height: 30),
                  const Divider(),
                  SizedBox(
                      height: 500,
                      child: ValueListenableBuilder(
                          valueListenable: ctrl.perguntasEvent,
                          builder: (context, value, child) {
                            if (value.isNotEmpty) {
                              List<PerguntaModel> list = value;
                              return ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: list.length,
                                  itemBuilder: (context, index) {
                                    PerguntaModel model = list[index];
                                    return Card(
                                        child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        TextComponent(
                                                            value:
                                                                "Pergunta ${index + 1}",
                                                            fontSize: 22),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        TextComponent(
                                                            color:
                                                                AppColor.medium,
                                                            value:
                                                                "Materia: ${model.materia.toString()}",
                                                            fontSize: 12),
                                                        const SizedBox(
                                                            width: 10),
                                                        TextComponent(
                                                            color:
                                                                AppColor.medium,
                                                            value:
                                                                "Assunto: ${model.assunto.toString()}",
                                                            fontSize: 12),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    ButtonIconCircularComponent(
                                                        iconColor:
                                                            AppColor.danger,
                                                        iconData: CupertinoIcons
                                                            .trash,
                                                        onPressed: () {
                                                          ctrl.removePergunta(
                                                              model, index);
                                                        })
                                                  ],
                                                )
                                              ],
                                            )));
                                  });
                            } else {
                              return Container();
                            }
                          })),
                ],
              ))));
        });
  }
}
