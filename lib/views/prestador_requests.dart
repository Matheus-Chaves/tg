import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tg/views/get_request.dart';

import '../controllers/request_controller.dart';
import '../models/request_model.dart';

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
                                  String status = requestController
                                      .requestList[index].status;
                                  RequestModel item =
                                      requestController.requestList[index];
                                  return Card(
                                    child: SizedBox(
                                      width: 300,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(children: [
                                          AutoSizeText(
                                            "Status: solicitação $status",
                                            maxLines: 1,
                                            minFontSize: 16,
                                            wrapWords: false,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500),
                                          ),
                                          if (item.statusPagamento != null)
                                            AutoSizeText(
                                              "${item.statusPagamento}",
                                              maxLines: 1,
                                              minFontSize: 16,
                                              wrapWords: false,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          const Divider(),
                                          AutoSizeText(
                                            item.descricao,
                                            maxLines: 4,
                                            overflow: TextOverflow.ellipsis,
                                            minFontSize: 16,
                                          ),
                                          const Divider(),
                                          status == "a aceitar"
                                              ? ElevatedButton(
                                                  onPressed: () async {
                                                    var res =
                                                        await requestController
                                                            .getRequest(
                                                                item.id);
                                                    Get.to(() => GetRequest(
                                                          request: res,
                                                          title:
                                                              "Gerenciar Solicitação",
                                                        ));
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: const [
                                                      Icon(Icons.adjust_sharp),
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                      Text(
                                                        "Gerenciar Solicitação",
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : status != "recusada"
                                                  ? ElevatedButton(
                                                      onPressed: () => {
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                  "Atenção!"),
                                                              content:
                                                                  SingleChildScrollView(
                                                                child: Column(
                                                                  children: [
                                                                    const Text(
                                                                        "Esta ação irá atualizar o status do serviço.\n\nEscolha o novo status:"),
                                                                    const SizedBox(
                                                                        height:
                                                                            24),
                                                                    DropdownButtonFormField(
                                                                      value:
                                                                          status,
                                                                      menuMaxHeight:
                                                                          300,
                                                                      hint: const Text(
                                                                          "Defina o status"),
                                                                      isExpanded:
                                                                          true,
                                                                      isDense:
                                                                          true,
                                                                      icon: const Icon(
                                                                          Icons
                                                                              .keyboard_arrow_down),
                                                                      items: [
                                                                        "em andamento",
                                                                        "concluída",
                                                                        "cancelada"
                                                                      ].map((String
                                                                          items) {
                                                                        return DropdownMenuItem(
                                                                          value:
                                                                              items,
                                                                          child:
                                                                              Text(items),
                                                                        );
                                                                      }).toList(),
                                                                      onChanged:
                                                                          (String?
                                                                              newValue) {
                                                                        setState(
                                                                            () {
                                                                          status =
                                                                              newValue!;
                                                                        });
                                                                      },
                                                                      decoration:
                                                                          const InputDecoration(
                                                                        border:
                                                                            OutlineInputBorder(),
                                                                        labelText:
                                                                            'Status',
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              actions: [
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: const Text(
                                                                      "Cancelar"),
                                                                ),
                                                                TextButton(
                                                                  onPressed:
                                                                      () async {
                                                                    RequestModel
                                                                        request =
                                                                        RequestModel(
                                                                      item.solicitanteId,
                                                                      item.servicoId,
                                                                      item.descricao,
                                                                      item.dataSolicitacao,
                                                                      status,
                                                                      item.id,
                                                                      item.prestadorId,
                                                                      statusPagamento:
                                                                          item.statusPagamento,
                                                                      observacao:
                                                                          item.observacao,
                                                                      valor: item
                                                                          .valor,
                                                                    );
                                                                    await requestController
                                                                        .updateRequest(
                                                                      request,
                                                                      tipoUsuario:
                                                                          "prestador",
                                                                    );
                                                                  },
                                                                  child: const Text(
                                                                      "Atualizar"),
                                                                )
                                                              ],
                                                            );
                                                          },
                                                        ),
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: const [
                                                          Icon(Icons.edit),
                                                          SizedBox(
                                                            width: 8,
                                                          ),
                                                          Text(
                                                            "Gerenciar Status",
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : const SizedBox.shrink(),
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
