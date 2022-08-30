import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

final List<String> imgList = [
  "assets/images/presentation_1.svg",
  "assets/images/presentation_2.svg",
  "assets/images/presentation_3.svg"
];

const List<Map<String, String>> cardList = [
  {
    "title": "Encontre o serviço ideal",
    "description":
        "Com várias opções de preço e categorias de trabalho, encontre a pessoa certa para sua necessidade."
  },
  {
    "title": "Venda seu trabalho",
    "description":
        "Apresente o que você faz, dê seu preço e comercialize seu serviço! Fácil, rápido e sem burocracia."
  },
  {
    "title": "Faça parte da equipe",
    "description":
        "Seja um cliente ou um vendedor! Crie sua conta e comece a fazer parte do nosso time ainda hoje."
  }
];

class Presentation extends StatefulWidget {
  const Presentation({Key? key}) : super(key: key);

  @override
  State<Presentation> createState() => _PresentationState();
}

class _PresentationState extends State<Presentation> {
  final PageController imgController = PageController();
  final PageController cardController = PageController();
  ValueNotifier<double> selectedIndex = ValueNotifier<double>(0.0);

  @override
  void dispose() {
    imgController.dispose();
    cardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification notification) {
                  if (notification.depth == 0 &&
                      notification is ScrollUpdateNotification) {
                    selectedIndex.value = imgController.page!;
                    if (cardController.page != imgController.page) {
                      cardController.position
                          // ignore: deprecated_member_use
                          .jumpToWithoutSettling(
                              imgController.position.pixels / 1);
                    }
                    setState(() {});
                  }
                  return false;
                },
                child: PageView(
                  controller: imgController,
                  children: imgList.asMap().entries.map((pageNumber) {
                    return SvgPicture.asset(
                      //height: height * (50.12 / 100),
                      imgList[pageNumber.key],
                      alignment: Alignment.topCenter,
                      clipBehavior: Clip.antiAlias,
                      fit: BoxFit.fill,
                      width: double.infinity,
                    );
                  }).toList(),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: imgList.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => _goToPage(entry.key),
                  child: Container(
                    width: 12.0,
                    height: 12.0,
                    margin: const EdgeInsets.only(
                      top: 8.0,
                      bottom: 16,
                      left: 2.0,
                      right: 2.0,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(
                        imgController.initialPage == entry.key ? 1 : 0.5,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(
              height: height * (38.80 / 100),
              child: PageView(
                controller: cardController,
                children: cardList.asMap().entries.map((pageNumber) {
                  return Card(
                    elevation: 1,
                    child: Center(
                      child: Column(
                        children: [
                          Text(cardList[pageNumber.key]["title"]!),
                          Text(cardList[pageNumber.key]["description"]!),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _goToPage(int page) {
    imgController.animateToPage(page,
        duration: const Duration(milliseconds: 200), curve: Curves.linear);
    cardController.animateToPage(page,
        duration: const Duration(milliseconds: 200), curve: Curves.linear);
  }
}
