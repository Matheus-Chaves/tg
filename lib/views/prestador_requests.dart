import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tg/views/get_request.dart';

import '../controllers/request_controller.dart';

class PrestadorRequests extends StatefulWidget {
  const PrestadorRequests({Key? key}) : super(key: key);

  @override
  State<PrestadorRequests> createState() => _PrestadorRequestsState();
}

class _PrestadorRequestsState extends State<PrestadorRequests> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RequestController>(
      init: RequestController(),
      initState: (_) {},
      builder: (requestController) {
        requestController.getClientRequests();
        return Scaffold(
          appBar: AppBar(
            title: const Text('Requisições'),
          ),
          body: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Suas requisições de serviços:",
                      style: TextStyle(fontSize: 20)),
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: Center(
                    child: requestController.isLoading
                        ? const CircularProgressIndicator()
                        : requestController.requestList.isEmpty
                            ? const Text(
                                "Ops!\nVocê ainda não tem nenhuma requisição.\n\nQuando contratarem um serviço seu, os detalhes aparecerão nesta tela!",
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
                                          ElevatedButton(
                                            onPressed: () async {
                                              var res = await requestController
                                                  .getRequest(requestController
                                                      .requestList[index]
                                                      .id as String);
                                              print(res.descricao);
                                              Get.to(() => GetRequest(
                                                    request: res,
                                                    title:
                                                        "Gerenciar Solicitação",
                                                  ));
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                Icon(Icons.adjust_sharp),
                                                SizedBox(
                                                  width: 8,
                                                ),
                                                Text(
                                                  "Gerenciar Solicitação",
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
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
