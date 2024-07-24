import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_enem/routes/app_pages.dart';
import 'package:quiz_enem/routes/app_routes.dart';
import 'package:quiz_enem/services/permissions.service.dart';
import 'package:quiz_enem/services/step_perguntas.service.dart';
import 'package:quiz_enem/ui/theme/app_theme.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Get.putAsync<PermissionsService>(() async => PermissionsService());
  await Get.putAsync<StepPerguntasService>(() async => StepPerguntasService());

  runApp(GetMaterialApp(
    title: 'Caderno de estudos',
    debugShowCheckedModeBanner: false,
    getPages: AppPages.routes,
    initialRoute: Routes.LOGIN,
    theme: appThemeData,
  ));
}
