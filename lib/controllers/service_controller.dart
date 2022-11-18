import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tg/auth.dart';
import 'package:tg/views/home_page.dart';

import '../models/service_model.dart';

class ServiceController extends GetxController {
  var isLoading = true;
  var serviceList = <ServiceModel>[];
  final User? user = Auth().currentUser;
  // Rx<List<ServiceModel>> serviceList = Rx<List<ServiceModel>>([]);
  // List<ServiceModel> get services => serviceList.value;

  Future<void> getServices() async {
    try {
      QuerySnapshot services = await FirebaseFirestore.instance
          .collection('servicos')
          .where("uid", isEqualTo: user!.uid)
          .get();
      serviceList.clear();
      for (var service in services.docs) {
        serviceList.add(ServiceModel(
          service['cpfPrestador'],
          service['categoria'],
          service['descricao'],
          service['valorMinimo'],
          service['uid'],
          service['dataCadastro'],
          id: service.id,
        ));
      }
      isLoading = false;
      update();
    } catch (e) {
      Get.snackbar('Erro em obter o serviço', e.toString());
    }
  }

  Future<void> createService(ServiceModel service) async {
    try {
      await FirebaseFirestore.instance
          .collection('servicos')
          .add(service.toJson());
      serviceList.clear();
      isLoading = false;
      update();
      Get.offAll(HomePage(
        tipoUsuario: "prestador",
      ));
    } catch (e) {
      Get.snackbar('Erro em criar o serviço.', e.toString());
    }
  }

  Future<ServiceModel> getService(String serviceId) async {
    try {
      var res = await FirebaseFirestore.instance
          .collection('servicos')
          .doc(serviceId)
          .get();
      return ServiceModel.fromDocumentSnapshot(docSnapshot: res);
    } catch (e) {
      Get.snackbar('Erro em criar o serviço.', e.toString());
      rethrow;
    }
  }

  Future<void> updateService(ServiceModel service) async {
    try {
      //ServiceModel model = await getService(serviceId);
      await FirebaseFirestore.instance
          .collection('servicos')
          .doc(service.id)
          .set(service.toJson(), SetOptions(merge: true));
      serviceList.clear();
      isLoading = false;
      update();
      Get.offAll(() => HomePage(tipoUsuario: "prestador"));
    } catch (e) {
      Get.snackbar('Erro em atualizar o serviço.', e.toString());
    }
  }

  Future<void> deleteService(String serviceId) async {
    try {
      await FirebaseFirestore.instance
          .collection('servicos')
          .doc(serviceId)
          .delete();
      serviceList.clear();
      isLoading = false;
      update();
      Get.to(() => HomePage(
            tipoUsuario: "prestador",
          ));
    } catch (e) {
      Get.snackbar('Erro em deletar o serviço.', e.toString());
    }
  }
}
