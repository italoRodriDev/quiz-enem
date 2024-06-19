import 'package:flutter/material.dart';
import 'package:flutter_crise/components/button.component.dart';
import 'package:flutter_crise/components/content.component.dart';
import 'package:flutter_crise/components/select.component.dart';
import 'package:flutter_crise/components/text.component.dart';
import 'package:get/get.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

import '../../../core/colors.dart';
import '../../../core/fonts/fonts.dart';
import 'widgets/editor.dart';

class CadastroPerguntaPage extends GetView {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.background,
        appBar: AppBar(
          title: TextComponent(
              value: 'Cadastrar', fontFamily: AppFont.Moonget, fontSize: 22),
        ),
        body: SafeArea(
            child: ContentComponent(
                content: SingleChildScrollView(
                    child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextComponent(value: 'Suas perguntas', fontSize: 22),
                ButtonStylizedComponent(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 1),
                    label: TextComponent(
                        value: 'Salvar',
                        fontFamily: AppFont.Moonget,
                        fontSize: 16),
                    onPressed: () {})
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
            ),
            const Divider(),
            const SizedBox(height: 10),
            EditorTexto()
          ],
        )))));
  }
}
