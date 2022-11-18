import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tg/models/user.dart';
import 'package:tg/views/login_page.dart';

import 'views/complete_profile.dart';
import 'views/home_page.dart';

class AuthController extends GetxController {
  static final AuthController instance = Get.find();
  // e-mail, senha, nome, cpf...
  late Rx<User?> _user;
  FirebaseAuth auth = FirebaseAuth.instance;

  User get user => _user.value!;

  @override
  void onInit() {
    super.onInit();
    _user = Rx<User?>(auth.currentUser);
    _user.bindStream(auth.userChanges());
    ever(_user, _initialScreen);
  }

  _initialScreen(User? user) async {
    if (user == null) {
      Get.to(() => const LoginPage());
      //Get.to(() => ui.SignInScreen(providers: [ui.EmailAuthProvider()]));
    } else {
      print("user value ${_user.value!.uid}");
      var data = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user.value!.uid)
          .get();
      if (data.data()!['tipoUsuario'] == null) {
        return Get.offAll(() => CompleteProfile());
      }
      return Get.offAll(() => HomePage());
    }
  }

  void register(String username, String email, String password) async {
    try {
      if (username.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
        UserCredential cred = await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        Usuario user = Usuario(
          nome: username,
          email: email,
          uid: cred.user!.uid,
        );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());
      } else {
        Get.snackbar(
          'Erro criando a conta!',
          'Por favor, preencha todos os campos.',
        );
      }
    } on FirebaseAuthException catch (error) {
      Get.snackbar("Erro de login", "$error");
    }
  }

  void login(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      Get.snackbar("Erro durante o Login", "$e.message");
    }
  }

  void logOut() async {
    Get.offAll(() => const LoginPage());
    await auth.signOut();
  }
}
