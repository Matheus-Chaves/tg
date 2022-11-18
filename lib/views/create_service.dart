import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tg/controllers/service_controller.dart';
import 'package:http/http.dart' as http;

import '../auth.dart';
import '../models/service_model.dart';

class CreateService extends StatefulWidget {
  const CreateService({Key? key}) : super(key: key);

  @override
  State<CreateService> createState() => _CreateServiceState();
}

class _CreateServiceState extends State<CreateService> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _descricao = TextEditingController();
  final TextEditingController _valorMinimo = TextEditingController();
  final User? user = Auth().currentUser;
  String? _categoria;

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

  getCpf(User? user) async {
    var userData = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();
    return userData.data()!['cpf'].toString();
  }

  @override
  Widget build(BuildContext context) {
    final ServiceController serviceController = Get.put(ServiceController());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Criar Serviço"),
      ),
      body: Center(
        child: Form(
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
                                onChanged: (String? newValue) {
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
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Valor mínimo',
                            hintText: "00.00",
                          ),
                        ),
                        TextField(
                          controller: _descricao,
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
                    ElevatedButton(
                      onPressed: () async {
                        String cpf = await getCpf(user);
                        serviceController.createService(
                          ServiceModel(
                            cpf.toString(),
                            _categoria!.trim(),
                            _descricao.text.trim(),
                            double.parse(_valorMinimo.text.trim()),
                            user!.uid,
                            Timestamp.now(),
                          ),
                        );
                      },
                      child: const Text("CADASTRAR"),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
