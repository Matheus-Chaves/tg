import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tg/screens/onboarding.dart';
import 'package:tg/themes/main_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: mainTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const Onboarding(),
        '/login': (context) => const Login(),
        '/home': (context) => const Home(),
      },
    );
  }
}

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController? textController1;
  TextEditingController? textController2;

  late bool passwordVisibility;
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    textController1 = TextEditingController();
    textController2 = TextEditingController();
    passwordVisibility = false;
  }

  @override
  void dispose() {
    textController1?.dispose();
    textController2?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leadingWidth: 64,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back, size: 32),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(24, 8, 24, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  'assets/images/login.svg',
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.3,
                  fit: BoxFit.cover,
                ),
                Text(
                  'Fazer Login',
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'E-mail:',
                        //style: FlutterFlowTheme.of(context).bodyText1,
                      ),
                      TextFormField(
                        controller: textController1,
                        autofocus: true,
                        obscureText: false,
                        decoration: InputDecoration(
                          hintText: 'email@job.com.br',
                          //hintStyle: FlutterFlowTheme.of(context).bodyText2,
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0x00000000),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0x00000000),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          prefixIcon: const Icon(
                            Icons.email_outlined,
                            size: 24,
                          ),
                        ),
                        //style: FlutterFlowTheme.of(context).bodyText1,
                        textAlign: TextAlign.start,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const Text(
                        'Senha:',
                        //style: FlutterFlowTheme.of(context).bodyText1,
                      ),
                      TextFormField(
                        controller: textController2,
                        autofocus: true,
                        obscureText: !passwordVisibility,
                        decoration: InputDecoration(
                          hintText: '••••••••',
                          //hintStyle: FlutterFlowTheme.of(context).bodyText2,
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0x00000000),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0x00000000),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            size: 24,
                          ),
                          suffixIcon: InkWell(
                            onTap: () => setState(
                              () => passwordVisibility = !passwordVisibility,
                            ),
                            focusNode: FocusNode(skipTraversal: true),
                            child: Icon(
                              passwordVisibility
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: const Color(0xFF757575),
                              size: 22,
                            ),
                          ),
                        ),
                        //style: FlutterFlowTheme.of(context).bodyText1,
                        textAlign: TextAlign.start,
                        keyboardType: TextInputType.visiblePassword,
                      ),
                      const Align(
                        alignment: AlignmentDirectional(1, 0),
                        child: Text(
                          'Esqueceu a senha?',
                          // style:
                          //     FlutterFlowTheme.of(context).bodyText2.override(
                          //           fontFamily: 'Poppins',
                          //           color: Color(0xFF269E14),
                          //         ),
                        ),
                      ),
                      Directionality(
                        textDirection: TextDirection.rtl,
                        child: SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: ElevatedButton.icon(
                              onPressed: () {
                                //Navigator.pushNamed(context, '/home');
                              },
                              icon: const Icon(Icons.arrow_back),
                              label: const Text("Entrar"),
                              style: ElevatedButton.styleFrom()
                              // ButtonStyle(
                              //   overlayColor: MaterialStateProperty.all(
                              //     Theme.of(context)
                              //         .colorScheme
                              //         .onBackground
                              //         .withOpacity(0.35),
                              //   ),
                              //   shape: MaterialStateProperty.all(
                              //     RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.circular(4),
                              //     ),
                              //   ),
                              //   backgroundColor: MaterialStateProperty.all(
                              //     Theme.of(context).colorScheme.primary,
                              //   ),
                              //   foregroundColor: MaterialStateProperty.all(
                              //     Theme.of(context).colorScheme.background,
                              //   ),
                              //   textStyle: MaterialStateProperty.resolveWith(
                              //     (states) => Theme.of(context)
                              //         .textTheme
                              //         .bodyMedium!
                              //         .copyWith(fontSize: 18),
                              //   ),
                              // ),
                              ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: const [
                          Expanded(child: Divider(endIndent: 12)),
                          Text("Ou"),
                          Expanded(child: Divider(indent: 12)),
                        ],
                      ),
                      Align(
                        alignment: const AlignmentDirectional(0, 0),
                        child: Stack(
                          alignment: const AlignmentDirectional(0, 0),
                          children: [
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: SizedBox(
                                width: double.infinity,
                                height: 40,
                                child: ElevatedButton(
                                  onPressed: () {
                                    //Navigator.pushNamed(context, '/home');
                                  },
                                  // style: ButtonStyle(
                                  //   overlayColor: MaterialStateProperty.all(
                                  //     Theme.of(context)
                                  //         .colorScheme
                                  //         .onBackground
                                  //         .withOpacity(0.35),
                                  //   ),
                                  //   shape: MaterialStateProperty.all(
                                  //     RoundedRectangleBorder(
                                  //       borderRadius:
                                  //           BorderRadius.circular(4),
                                  //     ),
                                  //   ),
                                  //   backgroundColor:
                                  //       MaterialStateProperty.all(
                                  //     Theme.of(context).colorScheme.primary,
                                  //   ),
                                  //   foregroundColor:
                                  //       MaterialStateProperty.all(
                                  //     Theme.of(context)
                                  //         .colorScheme
                                  //         .background,
                                  //   ),
                                  //   textStyle:
                                  //       MaterialStateProperty.resolveWith(
                                  //     (states) => Theme.of(context)
                                  //         .textTheme
                                  //         .bodyMedium!
                                  //         .copyWith(fontSize: 16),
                                  //   ),
                                  // ),
                                  child: const Text("Continuar com o Google"),
                                ),
                              ),
                            ),
                            Align(
                              alignment: const AlignmentDirectional(-0.83, 0),
                              child: Container(
                                width: 23,
                                height: 23,
                                clipBehavior: Clip.antiAlias,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                ),
                                child: Image.network(
                                  'https://i0.wp.com/nanophorm.com/wp-content/uploads/2018/04/google-logo-icon-PNG-Transparent-Background.png?w=1000&ssl=1',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Align(
                  alignment: AlignmentDirectional(0, 0),
                  child: Text(
                    'Não tem uma conta? Registre-se',
                    //style: FlutterFlowTheme.of(context).bodyText1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("TELA INICIAL - HOMEPAGE"),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Voltar"),
            )
          ],
        ),
      ),
    );
  }
}
