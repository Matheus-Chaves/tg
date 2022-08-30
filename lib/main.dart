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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: imgController,
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
                                Text(
                                  presentationData[index.key]["title"]!,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  textScaleFactor: 1.3,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(color: Colors.white),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  presentationData[index.key]["description"]!,
                                  maxLines: 3,
                                  textAlign: TextAlign.center,
                                  textScaleFactor: 1.25,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: Colors.white),
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
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              height: 80,
              margin: const EdgeInsets.only(top: 32),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {},
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
                        dotColor: Theme.of(context)
                            .colorScheme
                            .background
                            .withOpacity(0.35),
                        activeDotColor:
                            Theme.of(context).colorScheme.background,
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
                    onPressed: () {},
                    child: Text(
                      "PRÓXIMO",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontFamily: "Roboto"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
