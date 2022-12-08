import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tg/auth.dart';
import 'package:flutter/material.dart';
import 'package:tg/views/create_service.dart';
import 'package:tg/views/get_service.dart';

import '../controllers/service_controller.dart';

class PrestadorHomePage extends StatefulWidget {
  const PrestadorHomePage({Key? key}) : super(key: key);

  @override
  State<PrestadorHomePage> createState() => _PrestadorHomePageState();
}

class _PrestadorHomePageState extends State<PrestadorHomePage> {
  final User? user = Auth().currentUser;
  late final ServiceController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ServiceController());
  }

  @override
  Widget build(BuildContext context) {
    controller.update();
    return GetBuilder<ServiceController>(
      init: Get.put(ServiceController()),
      initState: (_) async {
        await controller.getServices();
        controller.update();
      },
      didUpdateWidget: (_, __) => controller.getServices(),
      autoRemove: false,
      builder: (serviceController) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Página inicial'),
          ),
          body: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  child: Center(
                    child: controller.isLoading
                        ? const CircularProgressIndicator()
                        : controller.serviceList.isEmpty
                            ? Container(
                                color: Colors.green.shade800,
                                padding: const EdgeInsets.all(12),
                                child: const Text(
                                  "Ops!\n\nParece que você ainda não criou nenhum serviço.\n\nClique no botão abaixo e comece agora mesmo!",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                              )
                            : ListView.separated(
                                itemCount: controller.serviceList.length,
                                itemBuilder: (BuildContext context, index) {
                                  return Card(
                                    child: SizedBox(
                                      width: 300,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(children: [
                                          AutoSizeText(
                                            "Valor mínimo: R\$ ${controller.serviceList[index].valorMinimo}",
                                            maxLines: 1,
                                            minFontSize: 16,
                                            wrapWords: false,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const Divider(),
                                          AutoSizeText(
                                            controller
                                                .serviceList[index].descricao,
                                            maxLines: 4,
                                            overflow: TextOverflow.ellipsis,
                                            minFontSize: 16,
                                          ),
                                          const Divider(),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () async {
                                                  var res = await controller
                                                      .getService(controller
                                                          .serviceList[index]
                                                          .id as String);
                                                  Get.to(() => GetService(
                                                        service: res,
                                                        title:
                                                            "Atualizar Serviço",
                                                      ));
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: const [
                                                    Icon(Icons.edit),
                                                    Text("Editar"),
                                                  ],
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: () => {
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: const Text(
                                                            "Atenção!"),
                                                        content: const Text(
                                                            "Tem certeza que quer deletar seu serviço?"),
                                                        actions: [
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                "Cancelar"),
                                                          ),
                                                          TextButton(
                                                            onPressed:
                                                                () async {
                                                              await controller
                                                                  .deleteService(controller
                                                                      .serviceList[
                                                                          index]
                                                                      .id as String);
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: const Text(
                                                                "Deletar"),
                                                          )
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: const [
                                                    Icon(Icons.delete),
                                                    Text('Deletar')
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ]),
                                      ),
                                    ),
                                  );
                                },
                                separatorBuilder:
                                    (BuildContext context, index) {
                                  return const Divider(
                                    thickness: 2,
                                    color: Colors.black,
                                  );
                                },
                              ),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: () => Get.to(() => const CreateService()),
                    child: const Text('Criar serviço'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
