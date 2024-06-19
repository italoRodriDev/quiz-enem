import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crise/components/text.component.dart';
import 'package:get/get.dart';
import 'package:quiz_enem/controllers/intro.controller.dart';
import 'package:quiz_enem/core/fonts/fonts.dart';
import 'package:quiz_enem/routes/app_routes.dart';
import 'package:rive/rive.dart';

import '../../../../core/colors.dart';

class IntroPage extends GetView {
  IntroController ctrl = Get.put(IntroController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<IntroController>(
        init: ctrl,
        builder: (_) {
          return Scaffold(
            backgroundColor: AppColor.background,
            body: Stack(children: [
              Positioned(
                  width: MediaQuery.of(context).size.width * 1.7,
                  bottom: 200,
                  left: 100,
                  child: Image.asset('assets/images/Spline.png')),
              Positioned.fill(
                  child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 10),
                      child: SizedBox())),
              const RiveAnimation.asset('assets/river/shapes.riv',
                  fit: BoxFit.cover),
              // -> Efeito ofuscado
              Positioned.fill(
                  child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 10),
                      child: const SizedBox())),
              SafeArea(
                  child: Column(children: [
                Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextComponent(
                            textAlign: TextAlign.left,
                            value: 'Café com',
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                            fontFamily: AppFont.Poppins),
                        TextComponent(
                            textAlign: TextAlign.left,
                            value: 'estudos',
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                            fontFamily: AppFont.Poppins,
                            height: 1.2),
                        const SizedBox(height: 5),
                        TextComponent(
                            textAlign: TextAlign.left,
                            value:
                                'Estude de maneira eficiente para suas provas.',
                            fontSize: 22,
                            height: 1.2),
                        const SizedBox(height: 5),
                      ],
                    )),
                const Spacer(flex: 2),
                Padding(
                    padding: const EdgeInsets.only(left: 40),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                            onTap: () {
                              ctrl.btnAnimCtrl.isActive = true;
                              ctrl.update();
                              Get.offAndToNamed(Routes.LISTA_PERGUNTAS);
                            },
                            child: SizedBox(
                              height: 64,
                              width: 260,
                              child: Stack(
                                children: [
                                  RiveAnimation.asset(
                                    'assets/river/button.riv',
                                    controllers: [_.btnAnimCtrl],
                                  ),
                                  Positioned.fill(
                                      top: 8,
                                      left: 15,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          TextComponent(
                                            value: 'Entrar',
                                            fontFamily: AppFont.Moonget,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          const SizedBox(width: 5),
                                          const Icon(
                                              CupertinoIcons.forward),
                                        ],
                                      ))
                                ],
                              ),
                            )),
                      ],
                    )),
                const Spacer(),
              ]))
            ]),
          );
        });
  }
}
