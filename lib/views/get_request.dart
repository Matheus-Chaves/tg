import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tg/controllers/request_controller.dart';
import 'package:tg/models/request_model.dart';

import '../auth.dart';

class GetRequest extends StatefulWidget {
  const GetRequest({Key? key, required this.request, required this.title})
      : super(key: key);
  final RequestModel request;
  final String title;

  @override
  State<GetRequest> createState() => _GetRequestState();
}

class _GetRequestState extends State<GetRequest> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _descricaoSolicitacao = TextEditingController();
  final TextEditingController _observacaoSolicitacao = TextEditingController();

  final User? user = Auth().currentUser;
  late final bool _readOnly;

  @override
  void initState() {
    super.initState();
    _descricaoSolicitacao.text = widget.request.descricao;
    _readOnly = widget.title != "Atualizar Solicitação";
  }

  @override
  Widget build(BuildContext context) {
    final RequestController requestController = Get.put(RequestController());
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Solicitação:",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    runSpacing: 12,
                    children: [
                      TextField(
                        controller: _descricaoSolicitacao,
                        readOnly: _readOnly,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Descrição',
                          hintMaxLines: 5,
                          hintText:
                              "Descreva com detalhes sua solicitação de serviço. Diga para quando precisa, onde e como será entregue, etc.",
                          alignLabelWithHint: true,
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  _readOnly
                      ? Wrap(
                          children: [
                            // DropdownButton(
                            //     items: [
                            //       DropdownMenuItem(child: Text("Aceitar")),
                            //       DropdownMenuItem(child: Text("Recusar")),
                            //       DropdownMenuItem(child: Text("Recusar")),
                            //     ],
                            //     value: _dropdownValue,
                            //     onChanged: ((value) {
                            //       setState(() {
                            //         _dropdownValue = value;
                            //       });
                            //     })),
                            RadioListTile(
                              title: const Text("Aceitar solicitação"),
                              value: "",
                              groupValue: "aceitar",
                              onChanged: (value) {
                                setState(() {});
                              },
                            ),
                            RadioListTile(
                              title: const Text("Recusar solicitação"),
                              value: "",
                              groupValue: "recusar",
                              onChanged: (value) {
                                setState(() {});
                              },
                            ),
                            const Text("Observação ou motivo da recusa:"),
                            TextField(
                              controller: _observacaoSolicitacao,
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Observação',
                                hintMaxLines: 5,
                                hintText:
                                    "Descreva com detalhes sua solicitação de serviço. Diga para quando precisa, onde e como será entregue, etc.",
                                alignLabelWithHint: true,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                onPressed: () async {
                                  // final RequestController requestController =
                                  //     Get.put(RequestController());
                                  // requestController.addRequest(
                                  //   RequestModel(
                                  //     user!.uid,
                                  //     widget.request.id as String,
                                  //     _descricaoSolicitacao.text.trim(),
                                  //     Timestamp.now(),
                                  //     "a aceitar",
                                  //   ),
                                  // );
                                },
                                child: const Text("SOLICITAR SERVIÇO"),
                              ),
                            )
                          ],
                        )
                      : SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            onPressed: () async {
                              RequestModel request = RequestModel(
                                widget.request.solicitanteId,
                                widget.request.servicoId,
                                _descricaoSolicitacao.text.trim(),
                                widget.request.dataSolicitacao,
                                widget.request.status,
                                widget.request.id,
                                widget.request.prestadorId,
                              );
                              await requestController.updateService(request);
                            },
                            child: const Text("ATUALIZAR"),
                          ),
                        )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
