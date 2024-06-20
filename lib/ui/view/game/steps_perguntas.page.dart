import 'package:flutter/material.dart';
import 'package:flutter_crise/components/text.component.dart';
import 'package:get/get.dart';
import 'package:quiz_enem/controllers/game.controller.dart';
import 'package:quiz_enem/services/step_perguntas.service.dart';
import 'package:quiz_enem/ui/view/game/widgets/visualizador_html.dart';

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
              body: SafeArea(
                  child: SingleChildScrollView(
                      child: SizedBox(
                          height: 750,
                          child: StreamBuilder<List<PerguntaModel>>(
                            stream: ctrl.getPerguntas(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List<PerguntaModel> list = snapshot.data!;
                                return StepsPerguntas(
                                  onSkip: (index) {
                                    FocusScope.of(context).unfocus();
                                    ctrl.respostaEvent.value = 'ND';
                                    ctrl.selectedValue = -1;
                                  },
                                  onBack: (index) {
                                    FocusScope.of(context).unfocus();
                                    ctrl.respostaEvent.value = 'ND';
                                     ctrl.selectedValue = -1;
                                  },
                                  onFinish: () {
                                    FocusScope.of(context).unfocus();
                                  },
                                  initialPage: 0,
                                  accentColor: AppColor.primary,
                                  stepsPages: [
                                    for (var item in list)
                                      StepPageData(
                                          title:
                                              'Questão ${list.indexOf(item) + 1}',
                                          contentPage: Padding(
                                              padding: const EdgeInsets.all(20),
                                              child: ValueListenableBuilder(
                                                  valueListenable:
                                                      ctrl.respostaEvent,
                                                  builder: (context,
                                                      String value, child) {
                                                    return Column(
                                                      children: [
                                                        const SizedBox(
                                                            height: 50),
                                                        VisualizadorHtml(
                                                            controller:
                                                                ctrl.quillCtrl,
                                                            textContent:
                                                                item.pergunta),
                                                        const SizedBox(
                                                            height: 10),
                                                        const Divider(),
                                                        Row(
                                                          children: [
                                                            TextComponent(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 22,
                                                                value:
                                                                    'Alterantivas'),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                            height: 8),
                                                        for (var i = 0;
                                                            i <
                                                                item.alternativas
                                                                    .length;
                                                            i++)
                                                          RadioListTile<int>(
                                                            title: TextComponent(
                                                                value: item
                                                                    .alternativas[
                                                                        i]
                                                                    .toString()),
                                                            value: i,
                                                            groupValue:
                                                                _.selectedValue,
                                                            onChanged:
                                                                (int? value) {
                                                              ctrl.setRespostaCorreta(
                                                                  value: value!,
                                                                  item: item);
                                                            },
                                                          ),
                                                      ],
                                                    );
                                                  }))),
                                  ],
                                );
                              } else if (snapshot.hasError) {
                                return Container();
                              } else {
                                return Center(
                                    child: Container(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: CircularProgressIndicator()));
                              }
                            },
                          )))));
        });
  }
}
