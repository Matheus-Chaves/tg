import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tg/binding/controller_binding.dart';
import 'package:tg/views/onboarding.dart';
import 'package:tg/views/splash_screen.dart';
import 'package:tg/themes/main_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'auth_controller.dart';
import 'firebase_options.dart';

void main() async {
  runApp(const SplashScreen());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // .then((val) => Get.put(() => AuthController()));
  await GetStorage.init();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool firstAccess = GetStorage().read('firstAccess') ?? true;
    //const bool firstAccess = true;
    return GetMaterialApp(
      theme: mainTheme,
      debugShowCheckedModeBanner: false,
      onReady: (() {
        //debugPrint(firstAccess.toString());
        firstAccess
            ? Get.to(() => const Onboarding())
            : Get.put(AuthController());
      }),
      initialBinding: ControllerBinding(),
      home: const SplashScreen(),
    );
  }
}
