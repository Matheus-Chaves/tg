import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';

import '../widgets/button_widget.dart';
import 'get_request.dart';
import '../controllers/request_controller.dart';
import '../models/request_model.dart';

class PrestadorRequests extends StatefulWidget {
  const PrestadorRequests({Key? key}) : super(key: key);

  @override
  State<PrestadorRequests> createState() => _PrestadorRequestsState();
}

class _PrestadorRequestsState extends State<PrestadorRequests> {
  UploadTask? task;
  File? file;
  final TextEditingController _observacao = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file!.path) : 'Nenhum selecionado';
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
                                              "- ${item.statusPagamento} -",
                                              maxLines: 1,
                                              minFontSize: 16,
                                              wrapWords: false,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          const Divider(),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: AutoSizeText(
                                              "Descrição da solicitação:\n${item.descricao}",
                                              maxLines: 4,
                                              overflow: TextOverflow.ellipsis,
                                              minFontSize: 16,
                                            ),
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
                                                            if (item.status ==
                                                                "cancelada") {
                                                              _observacao.text =
                                                                  item.observacao ??
                                                                      "";
                                                            }
                                                            return AlertDialog(
                                                              title: const Text(
                                                                  "Atenção!"),
                                                              content: StatefulBuilder(builder:
                                                                  (BuildContext
                                                                          context,
                                                                      StateSetter
                                                                          setState) {
                                                                return SingleChildScrollView(
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
                                                                            Icons.keyboard_arrow_down),
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
                                                                      if (status ==
                                                                          "concluída") ...[
                                                                        const SizedBox(
                                                                            height:
                                                                                24),
                                                                        const Text(
                                                                            "Para concluir o serviço, anexe o arquivo que será enviado ao cliente:"),
                                                                        const SizedBox(
                                                                            height:
                                                                                8),
                                                                        ButtonWidget(
                                                                          text:
                                                                              'Selecionar',
                                                                          icon:
                                                                              Icons.attach_file,
                                                                          onClicked:
                                                                              selectFile,
                                                                        ),
                                                                        const SizedBox(
                                                                            height:
                                                                                8),
                                                                        Text(
                                                                          fileName,
                                                                          style: const TextStyle(
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.w500),
                                                                        ),
                                                                        const SizedBox(
                                                                            height:
                                                                                16),
                                                                        ButtonWidget(
                                                                          text:
                                                                              'Enviar arquivo',
                                                                          icon:
                                                                              Icons.cloud_upload_outlined,
                                                                          onClicked:
                                                                              uploadFile,
                                                                        ),
                                                                        const SizedBox(
                                                                            height:
                                                                                8),
                                                                        task != null
                                                                            ? buildUploadStatus(task!)
                                                                            : Container()
                                                                      ],
                                                                      if (status ==
                                                                          'cancelada') ...[
                                                                        TextField(
                                                                          controller:
                                                                              _observacao,
                                                                          maxLines:
                                                                              null,
                                                                          keyboardType:
                                                                              TextInputType.multiline,
                                                                          decoration:
                                                                              const InputDecoration(
                                                                            border:
                                                                                OutlineInputBorder(),
                                                                            labelText:
                                                                                'Observação',
                                                                            hintMaxLines:
                                                                                5,
                                                                            hintText:
                                                                                "Descreva com detalhes o motivo de ter cancelado a solicitação.",
                                                                            alignLabelWithHint:
                                                                                true,
                                                                          ),
                                                                        ),
                                                                      ]
                                                                    ],
                                                                  ),
                                                                );
                                                              }),
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
                                                                    if (_observacao
                                                                        .text
                                                                        .isNotEmpty) {
                                                                      item.observacao = _observacao
                                                                          .text
                                                                          .trim();
                                                                    }
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

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path!;

    setState(() => file = File(path));
  }

  Future uploadFile() async {
    if (file == null) return;

    final fileName = basename(file!.path);
    final destination = 'files/$fileName';

    //task = FirebaseApi.uploadFile(destination, file!);
    setState(() {});

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    print('Download-Link: $urlDownload');
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);

            return Text(
              '$percentage %',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            );
          } else {
            return Container();
          }
        },
      );
}
