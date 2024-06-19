import 'package:flutter/material.dart';
import 'package:flutter_crise/components/text.component.dart';
import 'package:flutter_crise/components/button.component.dart';
import 'package:flutter_crise/components/content.component.dart';
import 'package:flutter_crise/components/select.component.dart';
import 'package:get/get.dart';
import 'package:quiz_enem/core/colors.dart';
import 'package:quiz_enem/core/fonts/fonts.dart';
import 'package:quiz_enem/routes/app_routes.dart';

class ListaPerguntasPage extends GetView {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.background,
        appBar: AppBar(
          title: TextComponent(
              value: 'Dashboard', fontFamily: AppFont.Moonget, fontSize: 22),
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
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 1),
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
                    menuItemData: [MenuItemData(label: 'Todos', value: 'ND')],
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: SelectComponent(
                    labelText: 'Assunto',
                    primaryColor: AppColor.primary,
                    initialValue: 'ND',
                    menuItemData: [MenuItemData(label: 'Todos', value: 'ND')],
                  ),
                ),
              ],
            )
          ],
        ))));
  }
}
