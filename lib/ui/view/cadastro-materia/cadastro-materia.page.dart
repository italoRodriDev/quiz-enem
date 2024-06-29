import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crise/components/button.component.dart';
import 'package:flutter_crise/components/content.component.dart';
import 'package:flutter_crise/components/input-text.component.dart';
import 'package:flutter_crise/components/text.component.dart';
import 'package:get/get.dart';
import 'package:quiz_enem/controllers/cadastro-materia.controller.dart';
import 'package:quiz_enem/core/colors.dart';
import 'package:quiz_enem/models/materia.model.dart';

import '../../../core/fonts/fonts.dart';

class CadastroMateriaPage extends GetView {
  CadastroMateriaController ctrl = Get.put(CadastroMateriaController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ctrl.context = context;
    return GetBuilder(
        init: ctrl,
        builder: (_) {
          return Scaffold(
              appBar: AppBar(
                actions: [
                  Padding(
                      padding: const EdgeInsets.all(10),
                      child: ButtonStylizedComponent(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 30),
                          borderRadius: 30,
                          label: TextComponent(
                              value: 'Matérias', fontFamily: AppFont.Moonget),
                          onPressed: () {
                            ctrl.saveData();
                          }))
                ],
                title: TextComponent(
                    value: 'Assuntos',
                    fontFamily: AppFont.Moonget,
                    fontSize: 22),
              ),
              body: SafeArea(
                  child: ContentComponent(
                      content: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              const SizedBox(height: 30),
                              InputTextComponent(
                                textEditingController: ctrl.materia,
                                labelText: 'Nome da matéria',
                                hintText: 'Digite o nome da matéria...',
                              ),
                              SizedBox(height: 30),
                              ButtonStylizedComponent(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 1),
                                  label: TextComponent(
                                      value: 'Salvar',
                                      fontFamily: AppFont.Moonget,
                                      fontSize: 16),
                                  onPressed: () {
                                    ctrl.saveData();
                                  }),
                              const SizedBox(height: 30),
                              const Divider(),
                              StreamBuilder<List<MateriaModel>>(
                                stream: ctrl.getMaterias(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    List<MateriaModel> list = snapshot.data!;
                                    return ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: list.length,
                                        itemBuilder: (context, index) {
                                          MateriaModel model = list[index];
                                          return Card(
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              TextComponent(
                                                                  value: model
                                                                      .nome,
                                                                  fontSize: 22),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          ButtonIconCircularComponent(
                                                              iconColor:
                                                                  AppColor
                                                                      .danger,
                                                              iconData:
                                                                  CupertinoIcons
                                                                      .trash,
                                                              onPressed: () {
                                                                ctrl.remove(
                                                                    model,
                                                                    index);
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
                                            padding:
                                                const EdgeInsets.only(top: 10),
                                            child:
                                                const CircularProgressIndicator()));
                                  }
                                },
                              ),
                            ],
                          )))));
        });
  }
}
