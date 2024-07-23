import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crise/components/button.component.dart';
import 'package:flutter_crise/components/text.component.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
import 'package:quiz_enem/models/assunto.model.dart';
import 'package:quiz_enem/models/materia.model.dart';
import 'package:quiz_enem/models/pergunta.model.dart';

import '../../../../core/colors.dart';

class CardPerguntas extends StatefulWidget {
  Color corCard;
  String materia;
  String assunto;
  PerguntaModel pergunta;
  Function onPressedRemove;
  int index;
  CardPerguntas(
      {super.key,
      required this.corCard,
      required this.index,
      required this.onPressedRemove,
      required this.pergunta,
      required this.materia,
      required this.assunto});

  @override
  State<CardPerguntas> createState() => _CardPerguntasState();
}

class _CardPerguntasState extends State<CardPerguntas> {
  FlutterTts flutterTts = FlutterTts();
  bool enabledSpeak = false;

  @override
  void initState() {
    super.initState();
    flutterTts.setLanguage("pt-BR");
  }

  Future<void> _speak() async {
    await flutterTts.speak(removeHtmlTagsTranslate(widget.pergunta.pergunta));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        color: widget.corCard,
        child: Container(
            height: 600,
            child: Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    Row(
                      children: [
                        TextComponent(
                            color: Colors.white,
                            value: "Pergunta ${widget.index + 1}",
                            fontSize: 22),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                            width: 190,
                            child: TextComponent(
                                color: Colors.white,
                                value: removeHtmlTags(
                                    widget.pergunta.pergunta.toString()),
                                fontSize: 12)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ButtonIconCircularComponent(
                            iconColor: Colors.white,
                            iconData: enabledSpeak == true ? CupertinoIcons.stop :
                                CupertinoIcons.antenna_radiowaves_left_right ,
                            onPressed: () {
                              enabledSpeak = !enabledSpeak;
                              if (enabledSpeak == true) {
                                _speak();
                              } else {
                                flutterTts.stop();
                              }
                              setState(() {
                                
                              });
                            }),
                        ButtonIconCircularComponent(
                            iconColor: AppColor.danger,
                            iconData: CupertinoIcons.trash,
                            onPressed: () {
                              widget.onPressedRemove(widget.index);
                            }),
                      ],
                    ),
                  ],
                ))));
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
