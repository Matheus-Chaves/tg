import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tg/controllers/request_controller.dart';
import 'package:tg/models/request_model.dart';
import 'package:tg/models/service_model.dart';
import 'package:http/http.dart' as http;

import '../auth.dart';
import '../controllers/service_controller.dart';

class GetService extends StatefulWidget {
  const GetService({Key? key, required this.service, required this.title})
      : super(key: key);
  final ServiceModel service;
  final String title;

  @override
  State<GetService> createState() => _GetServiceState();
}

class _GetServiceState extends State<GetService> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _descricao = TextEditingController();
  final TextEditingController _valorMinimo = TextEditingController();
  final TextEditingController _descricaoSolicitacao = TextEditingController();

  final User? user = Auth().currentUser;
  String? _categoria;
  late final bool _readOnly;

  Future<List<String>> getCategorias() async {
    var baseUrl = Uri(
      scheme: 'https',
      host: 'servicodados.ibge.gov.br',
      path: '/api/v2/cnae/secoes',
    );
    var response = await http.get(baseUrl);
    if (response.statusCode == 200) {
      List<String> items = [];
      var jsonData = json.decode(response.body) as List;
      for (var element in jsonData) {
        items.add(element["descricao"]);
      }
      items.sort((a, b) => a.toString().compareTo(b.toString()));
      return items;
    } else {
      throw response.statusCode;
    }
  }

  @override
  void initState() {
    super.initState();
    _descricao.text = widget.service.descricao;
    _valorMinimo.text = widget.service.valorMinimo.toString();
    _categoria = widget.service.categoria;
    _readOnly = widget.title == "Requisitar Serviço";
  }

  @override
  Widget build(BuildContext context) {
    final ServiceController serviceController = Get.put(ServiceController());
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
                      "Serviço:",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    runSpacing: 12,
                    children: [
                      FutureBuilder<List<String>>(
                        future: getCategorias(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var data = snapshot.data!;
                            return DropdownButtonFormField(
                              value: _categoria,
                              menuMaxHeight: 300,
                              hint: const Text("Escolha uma categoria"),
                              isExpanded: true,
                              isDense: true,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: data.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                              onChanged: _readOnly
                                  ? null
                                  : (String? newValue) {
                                      setState(() {
                                        _categoria = newValue!;
                                      });
                                    },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Categoria',
                              ),
                            );
                          } else {
                            return const CircularProgressIndicator();
                          }
                        },
                      ),
                      TextFormField(
                        controller: _valorMinimo,
                        readOnly: _readOnly,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Valor mínimo',
                          hintText: "00.00",
                        ),
                      ),
                      TextField(
                        controller: _descricao,
                        readOnly: _readOnly,
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Descrição',
                          hintMaxLines: 5,
                          hintText:
                              "Descreva com detalhes o serviço a ser prestado, o que é preciso para ele ser feito e o que será entregue ao cliente.",
                          alignLabelWithHint: true,
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  _readOnly
                      ? Wrap(
                          children: [
                            TextField(
                              controller: _descricaoSolicitacao,
                              maxLines: null,
                              keyboardType: TextInputType.multiline,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Descrição da solicitação',
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
                                  final RequestController requestController =
                                      Get.put(RequestController());
                                  requestController.addRequest(
                                    RequestModel(
                                        user!.uid,
                                        widget.service.id as String,
                                        _descricaoSolicitacao.text.trim(),
                                        Timestamp.now(),
                                        "a aceitar",
                                        FirebaseFirestore.instance
                                            .collection("requests")
                                            .doc()
                                            .id,
                                        widget.service.uid),
                                  );
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
                              serviceController.updateService(
                                ServiceModel(
                                  widget.service.cpfPrestador,
                                  _categoria!.trim(),
                                  _descricao.text.trim(),
                                  double.parse(_valorMinimo.text.trim()),
                                  widget.service.uid,
                                  widget.service.dataCadastro,
                                  dataAtualizacao: Timestamp.now(),
                                  id: widget.service.id,
                                ),
                              );
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
