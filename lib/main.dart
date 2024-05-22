import 'package:batevolta/routes/app_pages.dart';
import 'package:batevolta/routes/app_routes.dart';
import 'package:batevolta/services/permissions.service.dart';
import 'package:batevolta/ui/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Get.putAsync<PermissionsService>(() async => PermissionsService());
 
  runApp(GetMaterialApp(
    title: 'BateVolta',
    debugShowCheckedModeBanner: false,
    getPages: AppPages.routes,
    initialRoute: Routes.HOME_PASSAGEIRO,
    theme: appThemeData,
  ));
}
