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
  final TextEditingController _valorServico = TextEditingController();

  final User? user = Auth().currentUser;
  late final bool _readOnly;
  String isAccepted = "";

  @override
  void initState() {
    super.initState();
    _descricaoSolicitacao.text = widget.request.descricao;
    _readOnly = widget.title != "Atualizar Solicitação";
  }

  @override
  Widget build(BuildContext context) {
    final RequestController requestController = Get.put(RequestController());
    String? text;
    if (isAccepted == "em andamento") {
      text = "Observação (opcional)";
    } else if (isAccepted == "recusada") {
      text = "Motivo da recusa";
    }
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
                            RadioListTile(
                              title: const Text("Aceitar solicitação"),
                              value: "em andamento",
                              groupValue: isAccepted,
                              onChanged: (value) {
                                setState(() => isAccepted = "em andamento");
                              },
                            ),
                            RadioListTile(
                              title: const Text("Recusar solicitação"),
                              value: "recusada",
                              groupValue: isAccepted,
                              onChanged: (value) {
                                setState(() => isAccepted = "recusada");
                              },
                            ),
                            isAccepted == "em andamento"
                                ? Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: TextFormField(
                                      controller: _valorServico,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Valor final do serviço',
                                        hintText: "00.00",
                                      ),
                                    ),
                                  )
                                : const Divider(),
                            Text(text ?? ""),
                            const SizedBox(height: 24),
                            if (text != null)
                              TextField(
                                controller: _observacaoSolicitacao,
                                maxLines: null,
                                keyboardType: TextInputType.multiline,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Observação',
                                  hintMaxLines: 5,
                                  hintText:
                                      "Descreva com detalhes como você resolverá o pedido do cliente ou explique o motivo de ter recusado a solicitação.",
                                  alignLabelWithHint: true,
                                ),
                              ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                onPressed: () async {
                                  String? statusPagamento =
                                      isAccepted == "em andamento"
                                          ? "aguardando pagamento"
                                          : null;
                                  RequestModel request = RequestModel(
                                    widget.request.solicitanteId,
                                    widget.request.servicoId,
                                    _descricaoSolicitacao.text.trim(),
                                    widget.request.dataSolicitacao,
                                    isAccepted,
                                    widget.request.id,
                                    widget.request.prestadorId,
                                    statusPagamento: statusPagamento,
                                    observacao:
                                        _observacaoSolicitacao.text.trim(),
                                    valor: _valorServico.text.isNotEmpty
                                        ? double.parse(_valorServico.text
                                            .trim()
                                            .replaceFirst(",", "."))
                                        : null,
                                  );
                                  await requestController.updateRequest(
                                    request,
                                    tipoUsuario: "prestador",
                                  );
                                },
                                child: const Text("DEFINIR SOLICITAÇÃO"),
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
                                "a aceitar",
                                widget.request.id,
                                widget.request.prestadorId,
                                statusPagamento: widget.request.statusPagamento,
                                observacao: widget.request.observacao,
                                valor: widget.request.valor,
                              );
                              await requestController.updateRequest(
                                request,
                                tipoUsuario: "cliente",
                              );
                            },
                            child: const Text("ATUALIZAR"),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
