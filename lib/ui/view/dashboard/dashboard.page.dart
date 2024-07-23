import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crise/components/side-bar-drawer.component.dart';
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
import 'package:quiz_enem/ui/view/dashboard/widgets/card-perguntas.dart';

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
              drawer: Drawer(
                  child: ListView(
                children: [
                  SizedBox(
                    height: 220,
                    child: DrawerHeader(
                      margin: EdgeInsets.zero,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 24),
                      decoration: BoxDecoration(color: AppColor.primary),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 6),
                          TextComponent(
                            value: 'Olá, ${getGreeting()}',
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                          TextComponent(
                            value:
                                'A baixo você pode selecionar a matéria e o assunto para filtrar na tela inicial, ou pode cadastrar matérias, assuntos e perguntas.',
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.all(5),
                      child: Column(
                        children: [
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
                                List<MateriaModel> list = snapshot.data!;
                                List<MenuItemData> listMenu = [];

                                listMenu.add(const MenuItemData(
                                    label: 'Nenhuma', value: 'ND'));

                                for (var i in list) {
                                  listMenu.add(
                                      MenuItemData(label: i.nome, value: i.id));
                                }

                                return SelectComponent(
                                  initialValue: ctrl.idMateria,
                                  labelText: 'Matéria',
                                  menuItemData: listMenu,
                                  primaryColor: AppColor.primary,
                                  onChanged: (value) {
                                    if (value != 'ND') {
                                      var index = list.indexWhere(
                                          (element) => element.id == value);
                                      MateriaModel data = list[index];
                                      ctrl.idMateria = data.id;
                                      ctrl.materiaAtualEvent.value =
                                          data.nome.toString();
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
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator(); // Show a loading indicator while waiting for data
                              } else if (snapshot.hasError) {
                                return Text(
                                    'Error: ${snapshot.error}'); // Show an error message if there's an error
                              } else if (snapshot.hasData &&
                                  snapshot.data!.isNotEmpty) {
                                List<AssuntoModel> list = snapshot.data!;
                                List<MenuItemData> listMenu = [];

                                listMenu.add(const MenuItemData(
                                    label: 'Nenhuma', value: 'ND'));

                                for (var i in list) {
                                  listMenu.add(
                                      MenuItemData(label: i.nome, value: i.id));
                                }

                                return SelectComponent(
                                  labelText: 'Assunto',
                                  initialValue: ctrl.idAssunto,
                                  menuItemData: listMenu,
                                  primaryColor: AppColor.primary,
                                  onChanged: (value) {
                                    if (value != 'ND') {
                                      var index = list.indexWhere(
                                          (element) => element.id == value);
                                      AssuntoModel data = list[index];
                                      ctrl.idAssunto = data.id;
                                      ctrl.assuntoAtualEvent.value =
                                          data.nome.toString();
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
                          Row(
                            children: [
                              Expanded(
                                  child: ButtonStylizedComponent(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 1),
                                      label: TextComponent(
                                          value: 'Cadastrar nova pergunta',
                                          fontSize: 16),
                                      onPressed: () {
                                        Get.toNamed(Routes.CADASTRO_PERGUNTA);
                                      }))
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: ButtonStylizedComponent(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 1),
                                      label: TextComponent(
                                          value: 'Minhas matérias',
                                          fontSize: 16),
                                      onPressed: () {
                                        Get.toNamed(Routes.CADASTRO_MATERIA);
                                      }))
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: ButtonStylizedComponent(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 1),
                                      label: TextComponent(
                                          value: 'Meus assuntos',
                                          fontSize: 16),
                                      onPressed: () {
                                        Get.toNamed(Routes.CADASTRO_ASSUNTO);
                                      }))
                            ],
                          )
                        ],
                      ))
                ],
              )),
              backgroundColor: AppColor.background,
              appBar: AppBar(
                backgroundColor: AppColor.primary,
                title: TextComponent(
                    value: 'Anotações',
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
              ),
              body: SafeArea(
                  child: Stack(
                children: [
                  ContentComponent(
                      content: Column(
                    children: [
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          ValueListenableBuilder(
                              valueListenable: ctrl.materiaAtualEvent,
                              builder: (context, value, child) {
                                return TextComponent(
                                    value: value,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600);
                              })
                        ],
                      ),
                      Row(
                        children: [
                          ValueListenableBuilder(
                              valueListenable: ctrl.assuntoAtualEvent,
                              builder: (context, value, child) {
                                return TextComponent(
                                    value: value,
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.medium);
                              })
                        ],
                      ),
                      const SizedBox(height: 5),
                      const Divider(),
                      SizedBox(
                          height: 500,
                          child: ValueListenableBuilder(
                              valueListenable: ctrl.perguntasEvent,
                              builder: (context, value, child) {
                                if (value.isNotEmpty) {
                                  List<PerguntaModel> list = value;
                                  return GridView.builder(
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount:
                                          2, // Número de colunas no grid
                                      crossAxisSpacing: 10.0,
                                      mainAxisSpacing: 10.0,
                                    ),
                                    itemCount: list.length,
                                    itemBuilder: (context, index) {
                                      PerguntaModel model = list[index];
                                      return CardPerguntas(
                                        corCard: ctrl.corCard,
                                        index: index,
                                        onPressedRemove: (index) {
                                          ctrl.removePergunta(model, index);
                                        },
                                        materia: model.materia,
                                        assunto: model.assunto,
                                        pergunta: model,
                                      );
                                    },
                                  );
                                } else {
                                  return Center(
                                    child: TextComponent(
                                        value:
                                            'Selecione uma matéria e um assunto...'),
                                  );
                                }
                              })),
                    ],
                  )),
                  Positioned(
                      bottom: 0,
                      left: 50,
                      right: 50,
                      child: Row(
                        children: [
                          Expanded(
                              child: ButtonStylizedComponent(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 1),
                                  label: TextComponent(
                                      value: 'INICIAR GAME QUIZ', fontSize: 16),
                                  onPressed: () {
                                    Get.toNamed(Routes.STEP_PERGUNTAS);
                                  }))
                        ],
                      )),
                ],
              )));
        });
  }

  String getGreeting() {
    final int hour = DateTime.now().hour;

    if (hour >= 6 && hour < 12) {
      return 'Bom dia';
    } else if (hour >= 12 && hour < 18) {
      return 'Boa tarde';
    } else {
      return 'Boa noite';
    }
  }
}
