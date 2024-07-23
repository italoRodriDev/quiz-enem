import 'package:get/get.dart';
import 'package:quiz_enem/ui/view/auth/cadastro/cadastro.page.dart';
import 'package:quiz_enem/ui/view/auth/login/login.page.dart';
import 'package:quiz_enem/ui/view/cadastro-assunto/cadastro-assunto.page.dart';
import 'package:quiz_enem/ui/view/cadastro-materia/cadastro-materia.page.dart';
import 'package:quiz_enem/ui/view/cadastro-perguntas/cadastro_pergunta.page.dart';
import 'package:quiz_enem/ui/view/dashboard/dashboard.page.dart';
import 'package:quiz_enem/ui/view/game/steps_perguntas.page.dart';

import '../core/colors.dart';
import 'app_routes.dart';

const animation = Transition.fadeIn;
const timeAnimation = 300;

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginPage(),
      transition: animation,
      transitionDuration: const Duration(milliseconds: timeAnimation),
    ),
    GetPage(
      name: Routes.CADASTRO,
      page: () => CadastroPage(),
      transition: animation,
      transitionDuration: const Duration(milliseconds: timeAnimation),
    ),
    GetPage(
      name: Routes.DASH_BOARD,
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
      name: Routes.CADASTRO_ASSUNTO,
      page: () => CadastroAssuntoPage(),
      transition: animation,
      transitionDuration: const Duration(milliseconds: timeAnimation),
    ),
    GetPage(
      name: Routes.CADASTRO_MATERIA,
      page: () => CadastroMateriaPage(),
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
