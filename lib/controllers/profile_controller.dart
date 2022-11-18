import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../views/home_page.dart';

class ProfileController extends GetxController {
  static final ProfileController instance = Get.find();
  late Rx<User?> _user;
  FirebaseAuth auth = FirebaseAuth.instance;
  User get user => _user.value!;

  @override
  void onInit() {
    super.onInit();
    _user = Rx<User?>(auth.currentUser);
  }

  getData() async {
    try {
      var data = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user.value!.uid)
          .get();
      return {
        "cpf": data['cpf'],
        "uid": data['uid'],
        "tipoUsuario": data['tipoUsuario'],
        "dataDeNascimento": data['dataDeNascimento'],
        "email": data['email'],
        "nome": data['nome'],
        "telefone": data['telefone'],
        "cep": data['cep'],
        "estado": data['estado'],
        "cidade": data['cidade'],
        "logradouro": data['logradouro'],
        "numero": data['numero'],
        "complemento": data['complemento'],
        "createdAt": data['createdAt'],
        "updatedAt": data['updatedAt'],
      };
    } catch (e) {
      Get.snackbar("Erro em coletar as informações.", "$e");
    }
  }

  void addData(Map<String, dynamic> data) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_user.value!.uid)
          .set(data, SetOptions(merge: true));
      Get.offAll(() => HomePage());
    } catch (e) {
      Get.snackbar("Erro em registrar as informações.", "$e");
    }
  }
}
