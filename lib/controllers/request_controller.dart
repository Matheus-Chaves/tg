import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../auth.dart';
import '../models/request_model.dart';
import '../views/home_page.dart';

class RequestController extends GetxController {
  static final RequestController instance = Get.find();
  var isLoading = true;
  var requestList = <dynamic>[];
  final User? user = Auth().currentUser;

  void addRequest(RequestModel data) async {
    try {
      var json = data.toJson();
      await FirebaseFirestore.instance
          .collection('requisicoes')
          .doc(json['id'])
          .set(json);
      Get.offAll(() => const HomePage(tipoUsuario: "cliente"));
    } catch (e) {
      Get.snackbar("Erro em registrar a solicitação.", "$e");
    }
  }

  Future<void> getRequests() async {
    try {
      QuerySnapshot requests = await FirebaseFirestore.instance
          .collection('requisicoes')
          .where("solicitanteId", isEqualTo: user!.uid)
          .get();
      requestList.clear();

      for (var request in requests.docs) {
        requestList.add(RequestModel(
          request['solicitanteId'],
          request['servicoId'],
          request['descricao'],
          request['dataSolicitacao'],
          request['status'],
          request['id'],
          request['prestadorId'],
          statusPagamento: request['statusPagamento'],
          observacao: request['observacao'],
          valor: request['valor'],
        ));
      }
      isLoading = false;
      update();
    } catch (e) {
      Get.snackbar('Erro em obter a solicitação', e.toString());
    }
  }

  Future<void> getClientRequests() async {
    try {
      QuerySnapshot requests = await FirebaseFirestore.instance
          .collection('requisicoes')
          .where("prestadorId", isEqualTo: user!.uid)
          .get();
      requestList.clear();

      for (var request in requests.docs) {
        requestList.add(RequestModel(
          request['solicitanteId'],
          request['servicoId'],
          request['descricao'],
          request['dataSolicitacao'],
          request['status'],
          request['id'],
          request['prestadorId'],
          statusPagamento: request['statusPagamento'],
          observacao: request['observacao'],
          valor: request['valor'],
        ));
      }
      isLoading = false;
      update();
    } catch (e) {
      Get.snackbar('Erro em obter a solicitação', e.toString());
    }
  }

  Future<RequestModel> getRequest(String requestId) async {
    try {
      var res = await FirebaseFirestore.instance
          .collection('requisicoes')
          .doc(requestId)
          .get();
      return RequestModel.fromDocumentSnapshot(docSnapshot: res);
    } catch (e) {
      Get.snackbar('Erro em criar a solicitação.', e.toString());
      rethrow;
    }
  }

  Future<void> updateRequest(RequestModel request,
      {required tipoUsuario}) async {
    try {
      await FirebaseFirestore.instance
          .collection('requisicoes')
          .doc(request.id)
          .set(request.toJson(), SetOptions(merge: true));
      requestList.clear();
      isLoading = false;
      update();
      Get.offAll(() => HomePage(tipoUsuario: tipoUsuario));
    } catch (e) {
      Get.snackbar('Erro em atualizar a solicitação.', e.toString());
    }
  }

  Future<void> deleteRequest(String requestId) async {
    try {
      await FirebaseFirestore.instance
          .collection('requisicoes')
          .doc(requestId)
          .delete();
      requestList.clear();
      isLoading = false;
      update();
      Get.offAll(() => const HomePage(tipoUsuario: "cliente"));
    } catch (e) {
      Get.snackbar('Erro em deletar a solicitação.', e.toString());
    }
  }
}
