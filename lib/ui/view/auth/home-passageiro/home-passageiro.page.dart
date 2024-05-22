import 'package:batevolta/core/colors.dart';
import 'package:batevolta/ui/view/auth/home-passageiro/widgets/maps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crise/components/button.component.dart';
import 'package:flutter_crise/components/search.component.dart';
import 'package:flutter_crise/components/tabs.component.dart';
import 'package:flutter_crise/components/text.component.dart';
import 'package:get/get.dart';

import '../../../../services/permissions.service.dart';

class HomePassageiroPage extends GetView {
  @override
  Widget build(BuildContext context) {
    Get.find<PermissionsService>().requestPermissions();
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: SingleChildScrollView(
          child: Column(children: [
            Container(
                color: AppColor.warning,
                height: 60,
                child: Row(
                  children: [
                    const Icon(Icons.location_pin),
                    const SizedBox(width: 4),
                    Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextComponent(
                              value:
                                  'Compartilhamento de localização desativado.',
                              fontSize: 12,
                            ),
                            TextComponent(
                                value: 'Toque aqui para ativar...',
                                fontSize: 12),
                          ],
                        )),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward)
                  ],
                )),
            TabsComponent(
                fontSize: 16,
                colorTab: Colors.black,
                titlesTabs: ['Transporte urbano', 'Viagens'],
                contentTabs: [
                  buildTransporteUrbanoScreen(),
                  buildViagensScreen()
                ],
                onChangeIndex: (index) {},
                onChangeTitle: (index) {})
          ]),
        )));
  }

  Widget buildTransporteUrbanoScreen() {
    return Column(
      children: [
        const SizedBox(height: 5),
        const Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: SearchComponent(
                prefixIconData: Icons.search,
                hintText: 'Buscar empresa...',
                borderRadius: 32,
                verticalPadding: 10)),
        const SizedBox(height: 5),
        const SizedBox(
          height: 400,
          child: MapsComponent(),
        ),
        ButtonStylizedComponent(
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 8),
            onPressed: () {},
            label: TextComponent(value: 'Buscar transporte', fontFamily: 'Moonget', fontSize: 18,),
            borderRadius: 32,
            color: AppColor.primary)
      ],
    );
  }

  Widget buildViagensScreen() {
    return Container();
  }
}
