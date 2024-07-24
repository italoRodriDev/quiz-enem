import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crise/components/button.component.dart';
import 'package:flutter_crise/components/text.component.dart';
import 'package:get/get.dart';
import 'package:quiz_enem/models/pergunta.model.dart';

import '../../../../controllers/dashboard.controller.dart';
import '../../../../core/colors.dart';

class CardPerguntasMobile extends StatefulWidget {
  String materia;
  String assunto;
  PerguntaModel pergunta;
  Function onPressedRemove;
  int index;
  CardPerguntasMobile(
      {super.key,
      required this.index,
      required this.onPressedRemove,
      required this.pergunta,
      required this.materia,
      required this.assunto});

  @override
  State<CardPerguntasMobile> createState() => _CardPerguntasMobileState();
}

class _CardPerguntasMobileState extends State<CardPerguntasMobile> {
  DashBoardController ctrl = Get.put(DashBoardController());
  Color colorCard = Colors.yellow.withOpacity(0.8);

  @override
  void initState() {
    super.initState();
    ctrl.flutterTts.setLanguage("pt-BR");
    generateRandomColor();
  }

  Future<void> _speak() async {
    await ctrl.flutterTts
        .speak(removeHtmlTagsTranslate(widget.pergunta.pergunta));
  }

  generateRandomColor() {
    final Random random = Random();
    colorCard = Color.fromRGBO(
      random.nextInt(256), // Valor aleatório para o componente vermelho (0-255)
      random.nextInt(256), // Valor aleatório para o componente verde (0-255)
      random.nextInt(256), // Valor aleatório para o componente azul (0-255)
      1, // Opacidade (1.0 é completamente opaco)
    ).withOpacity(0.2);
  }

  @override
  Widget build(BuildContext context) {
    return buildCardMobile();
  }

  Widget buildCardMobile() {
    return Container(
      decoration: BoxDecoration(
        color: colorCard,
        borderRadius: BorderRadius.circular(10), // Bordas arredondadas
      ),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ButtonIconCircularComponent(
                  iconColor: Colors.black,
                  iconData: ctrl.enabledSpeak
                      ? CupertinoIcons.antenna_radiowaves_left_right
                      : CupertinoIcons.play,
                  onPressed: () {
                    setState(() {
                      ctrl.enabledSpeak = !ctrl.enabledSpeak;
                      if (ctrl.enabledSpeak) {
                        _speak();
                      } else {
                        ctrl.flutterTts.stop();
                      }
                    });
                  },
                ),
                ButtonIconCircularComponent(
                  iconColor: AppColor.danger,
                  iconData: CupertinoIcons.trash,
                  onPressed: () {
                    widget.onPressedRemove(widget.index);
                  },
                ),
              ],
            ),
            Row(
              children: [
                TextComponent(
                  color: Colors.black,
                  value: "Pergunta ${widget.index + 1}",
                  fontSize: 22,
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: SizedBox(
                        width: 190,
                        child: TextComponent(
                          color: Colors.black,
                          value: removeHtmlTags(
                              widget.pergunta.pergunta.toString()),
                          fontSize: 12,
                        ))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String removeHtmlTagsTranslate(String htmlText) {
    final RegExp exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return htmlText.replaceAll(exp, '');
  }

  String removeHtmlTags(String htmlText) {
    final RegExp exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return htmlText.replaceAll(exp, '').length > 150
        ? '${htmlText.replaceAll(exp, '').substring(0, 150)}...'
        : htmlText.replaceAll(exp, '');
  }
}
