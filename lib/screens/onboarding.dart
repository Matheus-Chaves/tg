import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

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

class Onboarding extends StatefulWidget {
  const Onboarding({Key? key}) : super(key: key);

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
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
                          presentationData[index.key]["path"]!,
                          alignment: Alignment.topCenter,
                          fit: BoxFit.fill,
                          width: double.infinity,
                        ),
                      ),
                      Card(
                        elevation: 0,
                        margin: const EdgeInsets.only(top: 32),
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
              duration: const Duration(milliseconds: 800),
              curve: Curves.decelerate,
              child: Container(
                margin: const EdgeInsets.only(top: 32),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
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
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          SmoothPageIndicator(
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
                          TextButton(
                            onPressed: () {
                              imgController.nextPage(
                                duration: const Duration(milliseconds: 1000),
                                curve: Curves.ease,
                              );
                            },
                            child: Text(
                              "PRÓXIMO",
                              style: Theme.of(context).textTheme.bodyMedium,
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
                            height: 45,
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/home');
                                },
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
                                        .copyWith(fontSize: 20),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/login');
                            },
                            child: FittedBox(
                              child: Text.rich(
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(fontSize: 16),
                                TextSpan(
                                  text: "Já possui uma conta? ",
                                  children: [
                                    TextSpan(
                                      text: "Faça o login",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 4,
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
