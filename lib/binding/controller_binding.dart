import 'package:get/get.dart';

import '../controllers/service_controller.dart';

class ControllerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ServiceController>(ServiceController());
  }
}
