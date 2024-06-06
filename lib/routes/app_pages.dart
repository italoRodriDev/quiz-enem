import 'package:get/get.dart';

import '../core/colors.dart';
import '../ui/view/auth/intro/intro.page.dart';
import '../ui/view/auth/splash/splash.page.dart';
import '../ui/view/tabs-menu/tabs_controller.component.dart';
import 'app_routes.dart';

const animation = Transition.fadeIn;
const timeAnimation = 300;

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => SplashPage(),
      transition: animation,
      transitionDuration: const Duration(milliseconds: timeAnimation),
    ),
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
  ];
}
