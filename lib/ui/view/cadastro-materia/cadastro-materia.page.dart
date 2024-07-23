import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crise/components/button.component.dart';
import 'package:flutter_crise/components/content.component.dart';
import 'package:flutter_crise/components/input-text.component.dart';
import 'package:flutter_crise/components/text.component.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:quiz_enem/controllers/cadastro-materia.controller.dart';
import 'package:quiz_enem/core/colors.dart';
import 'package:quiz_enem/models/materia.model.dart';

import '../../../core/fonts/fonts.dart';
import '../../../routes/app_routes.dart';

class CadastroMateriaPage extends GetView {
  CadastroMateriaController ctrl = Get.put(CadastroMateriaController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ctrl.context = context;
    return GetBuilder(
        init: ctrl,
        builder: (_) {
          return WillPopScope(
              onWillPop: () async => false,
              child: LoadingOverlay(
                  opacity: 1.0,
                  progressIndicator:
                      CircularProgressIndicator(color: AppColor.primary),
                  color: Colors.white,
                  isLoading: ctrl.isLoading,
                  child: Scaffold(
                      appBar: AppBar(
                        automaticallyImplyLeading: false,
                        backgroundColor: AppColor.primary,
                        title: TextComponent(
                            value: 'Minhas matérias', fontSize: 22),
                        actions: [
                          Padding(
                              padding: const EdgeInsets.all(5),
                              child: ButtonStylizedComponent(
                                  color: AppColor.danger,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 1),
                                  label: TextComponent(
                                      value: 'Voltar', fontSize: 16),
                                  onPressed: () {
                                    Get.offAndToNamed(Routes.DASH_BOARD);
                                  })),
                        ],
                      ),
                      body: SafeArea(
                          child: ContentComponent(
                              content: Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      TextComponent(
                                          value: 'Cadastre uma nova matéria',
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold),
                                      const SizedBox(height: 10),
                                      InputTextComponent(
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        textEditingController: ctrl.materia,
                                        labelText: 'Nome da matéria',
                                        hintText: 'Digite o nome da matéria...',
                                      ),
                                      const SizedBox(height: 30),
                                      Row(
                                        children: [
                                          ButtonStylizedComponent(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 1),
                                              label: TextComponent(
                                                  value: 'Salvar',
                                                  fontSize: 16),
                                              onPressed: () {
                                                ctrl.saveData();
                                              }),
                                        ],
                                      ),
                                      const SizedBox(height: 30),
                                      const Divider(),
                                      StreamBuilder<List<MateriaModel>>(
                                        stream: ctrl.getMaterias(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            List<MateriaModel> list =
                                                snapshot.data!;
                                            return ListView.builder(
                                                scrollDirection: Axis.vertical,
                                                shrinkWrap: true,
                                                itemCount: list.length,
                                                itemBuilder: (context, index) {
                                                  MateriaModel model =
                                                      list[index];
                                                  return Card(
                                                      color: AppColor.primary,
                                                      child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10),
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
                                                                      SizedBox(
                                                                          width:
                                                                              320,
                                                                          child: TextComponent(
                                                                              color: Colors.white,
                                                                              value: model.nome,
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: 18)),
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
                                                                      onPressed:
                                                                          () {
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
                                                        const EdgeInsets.only(
                                                            top: 10),
                                                    child:
                                                        const CircularProgressIndicator()));
                                          }
                                        },
                                      ),
                                    ],
                                  )))))));
        });
  }
}
