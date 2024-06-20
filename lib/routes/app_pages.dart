import 'package:get/get.dart';
import 'package:quiz_enem/ui/view/cadastro-perguntas/cadastro_pergunta.page.dart';
import 'package:quiz_enem/ui/view/dashboard/dashboard.page.dart';
import 'package:quiz_enem/ui/view/game/steps_perguntas.page.dart';

import '../core/colors.dart';
import '../ui/view/auth/intro/intro.page.dart';
import '../ui/view/tabs-menu/tabs_controller.component.dart';
import 'app_routes.dart';

const animation = Transition.fadeIn;
const timeAnimation = 300;

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.INTRO,
      page: () => IntroPage(),
      transition: animation,
      transitionDuration: const Duration(milliseconds: timeAnimation),
    ),
    GetPage(
      name: Routes.TABS_MENU,
      page: () => TabsControllerComponent(
          itemsMenu: [], primaryColor: AppColor.primary),
      transition: animation,
      transitionDuration: const Duration(milliseconds: timeAnimation),
    ),
    GetPage(
      name: Routes.LISTA_PERGUNTAS,
      page: () => DashBoardPage(),
      transition: animation,
      transitionDuration: const Duration(milliseconds: timeAnimation),
    ),
    GetPage(
      name: Routes.CADASTRO_PERGUNTA,
      page: () => CadastroPerguntaPage(),
      transition: animation,
      transitionDuration: const Duration(milliseconds: timeAnimation),
    ),
    GetPage(
      name: Routes.STEP_PERGUNTAS,
      page: () => StepsPerguntasPage(),
      transition: animation,
      transitionDuration: const Duration(milliseconds: timeAnimation),
    ),
  ];
}
