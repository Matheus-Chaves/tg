import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tg/auth_controller.dart';
import 'package:tg/views/login_page.dart';

const List<Map<String, String>> presentationData = [
  {
    "path": "assets/images/presentation_1.svg",
    "title": "Ache o serviço ideal",
    "description":
        // "Com várias opções de preço e categorias de trabalho, encontre a pessoa certa para sua necessidade."
        "Encontre a pessoa certa para sua necessidade em meio a várias opções de serviço."
  },
  {
    "path": "assets/images/presentation_2.svg",
    "title": "Venda seu trabalho",
    "description":
        "Apresente-se, dê seu preço e comercialize seu serviço! Fácil, rápido e sem burocracia."
  },
  {
    "path": "assets/images/presentation_3.svg",
    "title": "Faça parte da equipe",
    "description":
        "Seja um cliente ou vendedor! Venha fazer parte do nosso time ainda hoje."
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
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SvgPicture.asset(
                        presentationData[index.key]["path"]!,
                        //alignment: Alignment.topCenter,
                        fit: BoxFit.fill,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.53,
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
                                AutoSizeText(
                                  presentationData[index.key]["title"]!,
                                  maxLines: 1,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                                const SizedBox(height: 16),
                                AutoSizeText(
                                  presentationData[index.key]["description"]!,
                                  maxLines: 3,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
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
            Container(
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
                  : SizedBox(
                      width: double.infinity,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final prefs = GetStorage();
                            prefs.write('firstAccess', false);

                            Get.isRegistered<AuthController>()
                                ? Get.to(() => const LoginPage())
                                : Get.put(AuthController());
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
            ),
          ],
        ),
      ),
    );
  }
}
