import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tg/views/get_service.dart';

import '../auth.dart';
import '../controllers/service_controller.dart';

class ClienteHomePage extends StatefulWidget {
  const ClienteHomePage({Key? key}) : super(key: key);

  @override
  State<ClienteHomePage> createState() => _ClienteHomePageState();
}

class _ClienteHomePageState extends State<ClienteHomePage> {
  final User? user = Auth().currentUser;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ServiceController>(
      init: ServiceController(),
      initState: (_) {},
      builder: (serviceController) {
        serviceController.getServices();
        return Scaffold(
          appBar: AppBar(
            title: const Text('Página inicial'),
          ),
          body: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Encontre serviços abaixo:",
                      style: TextStyle(fontSize: 20)),
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: Center(
                    child: serviceController.isLoading
                        ? const CircularProgressIndicator()
                        : serviceController.serviceList.isEmpty
                            ? const Text(
                                "Ops! Parece que não há nenhum serviço cadastrado no sistema.\nCrie um perfil de prestador de serviços e cadastre o seu, ou convide um amigo para utilizar o app!",
                              )
                            : ListView.separated(
                                itemCount: serviceController.serviceList.length,
                                itemBuilder: (BuildContext context, index) {
                                  return Card(
                                    child: SizedBox(
                                      width: 300,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(children: [
                                          AutoSizeText(
                                            "Valor mínimo: R\$ ${serviceController.serviceList[index].valorMinimo}",
                                            maxLines: 1,
                                            minFontSize: 16,
                                            wrapWords: false,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const Divider(),
                                          AutoSizeText(
                                            serviceController
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
                                                  var res =
                                                      await serviceController
                                                          .getService(
                                                              serviceController
                                                                  .serviceList[
                                                                      index]
                                                                  .id as String);
                                                  Get.to(() => GetService(
                                                        service: res,
                                                        title:
                                                            "Requisitar Serviço",
                                                      ));
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: const [
                                                    Icon(Icons
                                                        .monetization_on_sharp),
                                                    Text("Contratar serviço"),
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
              ],
            ),
          ),
        );
      },
    );
  }
}
