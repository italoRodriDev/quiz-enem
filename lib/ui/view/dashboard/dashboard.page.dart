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
import 'package:quiz_enem/models/pergunta.model.dart';
import 'package:quiz_enem/routes/app_routes.dart';

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
                      SizedBox(
                        width: 200,
                        child: SelectComponent(
                          labelText: 'Matéria',
                          primaryColor: AppColor.primary,
                          initialValue: 'ND',
                          menuItemData: [
                            MenuItemData(label: 'Todos', value: 'ND'),
                            MenuItemData(label: 'Matemática', value: 'Matemática'),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 200,
                        child: SelectComponent(
                          labelText: 'Assunto',
                          primaryColor: AppColor.primary,
                          initialValue: 'ND',
                          menuItemData: [
                            MenuItemData(label: 'Todos', value: 'ND'),
                            MenuItemData(label: 'Algoritmos', value: 'Algoritmos'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                      height: 500,
                      child: StreamBuilder<List<PerguntaModel>>(
                        stream: ctrl.getPerguntas(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<PerguntaModel> list = snapshot.data!;
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
                                                MainAxisAlignment.spaceBetween,
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
                                                      const SizedBox(width: 10),
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
                                                      iconData:
                                                          CupertinoIcons.trash,
                                                      onPressed: () {
                                                        ctrl.removePergunta(
                                                            model, index);
                                                      })
                                                ],
                                              )
                                            ],
                                          )));
                                });
                          } else if (snapshot.hasError) {
                            return Container();
                          } else {
                            return Center(
                                child: Container(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: CircularProgressIndicator()));
                          }
                        },
                      )),
                ],
              ))));
        });
  }
}
