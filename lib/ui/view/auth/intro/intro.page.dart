import 'package:batevolta/core/colors.dart';
import 'package:batevolta/core/fonts/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crise/components/button.component.dart';
import 'package:flutter_crise/components/text.component.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class IntroPage extends GetView {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.background,
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                  padding: EdgeInsets.only(top: 25),
                  child: Center(
                      child: Image.asset('assets/images/logo_intro.png',
                          width: 200))),
              const SizedBox(height: 20),
              SvgPicture.asset('assets/images/vetor_intro.svg', width: 300),
              TextComponent(
                  value: 'Cansado de ir trabalhar de ônibus?',
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.bold,
                  fontSize: 17),
              const SizedBox(height: 4),
              TextComponent(
                  value: 'Junta a galera do trabalho e se joga nessa viagem!',
                  textAlign: TextAlign.center,
                  fontSize: 13),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 40, right: 40),
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ButtonComponent(
                        onPressed: () {},
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        label: 'Sou motorista',
                        borderRadius: 34,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ButtonOutlineComponent(
                        onPressed: () {},
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        label: 'Quero carona',
                        borderRadius: 34,
                        outlineColor: AppColor.medium,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ButtonOutlineComponent(
                        onPressed: () {},
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        label: 'Cadastre-se',
                        borderRadius: 34,
                        textColor: Colors.black,
                        outlineColor: Colors.transparent,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )));
  }
}
