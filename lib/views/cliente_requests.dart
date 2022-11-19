import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tg/views/get_request.dart';

import '../controllers/request_controller.dart';

class ClienteRequests extends StatefulWidget {
  const ClienteRequests({Key? key}) : super(key: key);

  @override
  State<ClienteRequests> createState() => _ClienteRequestsState();
}

class _ClienteRequestsState extends State<ClienteRequests> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RequestController>(
      init: RequestController(),
      initState: (_) {},
      builder: (requestController) {
        requestController.getRequests();
        return Scaffold(
          appBar: AppBar(
            title: const Text('Solicitações'),
          ),
          body: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Suas solicitações:",
                      style: TextStyle(fontSize: 20)),
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: Center(
                    child: requestController.isLoading
                        ? const CircularProgressIndicator()
                        : requestController.requestList.isEmpty
                            ? const Text(
                                "Ops! Você ainda não solicitou nenhum serviço.\nVá para a página inicial e contrate um serviço!",
                              )
                            : ListView.separated(
                                itemCount: requestController.requestList.length,
                                itemBuilder: (BuildContext context, index) {
                                  return Card(
                                    child: SizedBox(
                                      width: 300,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(children: [
                                          AutoSizeText(
                                            "Status: ${requestController.requestList[index].status}",
                                            maxLines: 1,
                                            minFontSize: 16,
                                            wrapWords: false,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const Divider(),
                                          AutoSizeText(
                                            requestController
                                                .requestList[index].descricao,
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
                                                      await requestController
                                                          .getRequest(
                                                              requestController
                                                                  .requestList[
                                                                      index]
                                                                  .id as String);
                                                  print(res.descricao);
                                                  Get.to(() => GetRequest(
                                                        request: res,
                                                        title:
                                                            "Atualizar Solicitação",
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
                                                            "Tem certeza que quer deletar sua solicitação?"),
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
                                                              await requestController
                                                                  .deleteRequest(
                                                                      requestController
                                                                          .requestList[
                                                                              index]
                                                                          .id);
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
              ],
            ),
          ),
        );
      },
    );
  }
}
