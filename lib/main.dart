import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tg/themes/main_theme.dart';

const List<Map<String, String>> presentationData = [
  {
    "path": "assets/images/presentation_1.svg",
    "title": "Encontre o serviço ideal",
    "description":
        "Com várias opções de preço e categorias de trabalho, encontre a pessoa certa para sua necessidade."
  },
  {
    "path": "assets/images/presentation_2.svg",
    "title": "Venda seu trabalho",
    "description":
        "Apresente o que você faz, dê seu preço e comercialize seu serviço! Fácil, rápido e sem burocracia."
  },
  {
    "path": "assets/images/presentation_3.svg",
    "title": "Faça parte da equipe",
    "description":
        "Seja um cliente ou um vendedor! Crie sua conta e comece a fazer parte do nosso time ainda hoje."
  }
];

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
      //title: 'Flutter Demo',
      theme: mainTheme,
      debugShowCheckedModeBanner: false,
      home: const Presentation(),
    );
  }
}

class Presentation extends StatefulWidget {
  const Presentation({Key? key}) : super(key: key);

  @override
  State<Presentation> createState() => _PresentationState();
}

class _PresentationState extends State<Presentation> {
  final PageController imgController = PageController();
  static const onboardingGreen = Color(0xFF078D6D);
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: onboardingGreen,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: imgController,
                onPageChanged: (index) {
                  setState(() => isLastPage = index == 2);
                },
                children: presentationData.asMap().entries.map((index) {
                  return Column(
                    children: [
                      Expanded(
                        child: SvgPicture.asset(
                          //height: height * (50.12 / 100),
                          presentationData[index.key]["path"]!,
                          alignment: Alignment.topCenter,
                          clipBehavior: Clip.antiAlias,
                          fit: BoxFit.fill,
                          width: double.infinity,
                        ),
                      ),
                      Card(
                        elevation: 0,
                        margin: const EdgeInsets.only(top: 16),
                        color: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Center(
                            child: Column(
                              children: [
                                FittedBox(
                                  child: Text(
                                    presentationData[index.key]["title"]!,
                                    maxLines: 1,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 64,
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                AutoSizeText(
                                  presentationData[index.key]["description"]!,
                                  maxLines: 3,
                                  textAlign: TextAlign.center,
                                  textScaleFactor: 1.24,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 56,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
            AnimatedSize(
              alignment: isLastPage ? Alignment.center : Alignment.bottomLeft,
              duration: const Duration(milliseconds: 900),
              curve: Curves.fastOutSlowIn,
              child: Container(
                //duration: const Duration(milliseconds: 700),
                //height: isLastPage ? 110 : 90,
                margin: const EdgeInsets.only(top: 32),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                ),
                child: !isLastPage
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              imgController.animateToPage(
                                2,
                                duration: const Duration(milliseconds: 1000),
                                curve: Curves.ease,
                              );
                            },
                            style: const ButtonStyle(),
                            child: Text(
                              "PULAR",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(fontFamily: "Roboto"),
                            ),
                          ),
                          Center(
                            child: SmoothPageIndicator(
                              controller: imgController,
                              count: 3,
                              effect: WormEffect(
                                spacing: 8,
                                dotHeight: 14,
                                dotWidth: 14,
                                type: WormType.thin,
                                dotColor: onboardingGreen.withOpacity(0.35),
                                activeDotColor: onboardingGreen,
                              ),
                              onDotClicked: (page) {
                                imgController.animateToPage(
                                  page,
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.ease,
                                );
                              },
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              imgController.nextPage(
                                duration: const Duration(milliseconds: 1000),
                                curve: Curves.ease,
                              );
                            },
                            child: Text(
                              "PRÓXIMO",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(fontFamily: "Roboto"),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          // const Divider(),
                          const SizedBox(
                            height: 8,
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: ElevatedButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.arrow_back),
                                label: const Text("Começar"),
                                style: ButtonStyle(
                                  overlayColor: MaterialStateProperty.all(
                                    Theme.of(context)
                                        .colorScheme
                                        .onBackground
                                        .withOpacity(0.35),
                                  ),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  backgroundColor: MaterialStateProperty.all(
                                    Theme.of(context).colorScheme.primary,
                                  ),
                                  foregroundColor: MaterialStateProperty.all(
                                    Theme.of(context).colorScheme.background,
                                  ),
                                  textStyle: MaterialStateProperty.resolveWith(
                                    (states) => Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontSize: 20,
                                          fontFamily: 'Roboto',
                                        ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: FittedBox(
                              child: Text.rich(
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      fontSize: 16,
                                      fontFamily: 'Roboto',
                                    ),
                                TextSpan(
                                  text: "Já possui uma conta? ",
                                  children: [
                                    TextSpan(
                                      text: "Faça o login",
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
