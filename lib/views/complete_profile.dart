import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tg/controllers/profile_controller.dart';

Map<String, dynamic> data = {
  "tipoUsuario": [],
  "cpf": '',
  "dataDeNascimento": '',
  "telefone": '',
  "cep": '',
  "estado": '',
  "cidade": '',
  "logradouro": '',
  "numero": '',
  "complemento": '',
  "updatedAt": '',
};

class CompleteProfile extends StatelessWidget {
  final PageController _controller = PageController();
  final _formKey = GlobalKey<FormState>();

  CompleteProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Complete seu perfil",
          style: TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: PageView(
          controller: _controller,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Eu quero ser...?",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    elevation: 5,
                    child: InkWell(
                      onTap: () {
                        data["tipoUsuario"] = ["cliente"];
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                        );
                      },
                      //splashColor: Colors.green.shade100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.person,
                            size: 56,
                            color: Color.fromARGB(255, 56, 142, 60),
                          ),
                          Text(
                            "Cliente",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    elevation: 5,
                    child: InkWell(
                      onTap: () {
                        data["tipoUsuario"] = ["prestador"];
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                        );
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.work, size: 56),
                          Text("Prestador de Serviços"),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            FormUsuario(formKey: _formKey, pageController: _controller),
          ],
        ),
      ),
    );
  }
}

class FormUsuario extends StatefulWidget {
  const FormUsuario(
      {Key? key,
      required GlobalKey<FormState> formKey,
      required PageController pageController})
      : _formKey = formKey,
        _controller = pageController,
        super(key: key);

  final GlobalKey<FormState> _formKey;
  final PageController _controller;

  @override
  State<FormUsuario> createState() => _FormUsuarioState();
}

// Mixin necessário para manter o estado do form ao voltar no PageView
class _FormUsuarioState extends State<FormUsuario>
    with AutomaticKeepAliveClientMixin<FormUsuario> {
  final ProfileController _profileController = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 16),
      child: Form(
        key: widget._formKey,
        child: Column(
          children: [
            const Text("Preencha os campos abaixo (obrigatório)"),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "CPF *",
                      hintText: "000.000.000-00",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'O campo é obrigatório.';
                      }
                      return null;
                    },
                    onSaved: (value) => data["cpf"] = value!,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.datetime,
                    decoration: const InputDecoration(
                      labelText: "Data de Nascimento *",
                      hintText: "dd/mm/yyyy",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'O campo é obrigatório.';
                      }
                      return null;
                    },
                    onSaved: (value) => data["dataDeNascimento"] = value!,
                  ),
                )
              ],
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Telefone (fixo ou celular) *",
                hintText: "+00 (00) 99999-9999",
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'O campo é obrigatório.';
                }
                return null;
              },
              onSaved: (value) => data['telefone'] = value!,
            ),
            const Divider(height: 24),
            const Text("Informações complementares"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "CEP",
                      hintText: "00000000",
                    ),
                    onSaved: (value) => data['cep'] = value!,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Estado",
                      hintText: "Estado - UF",
                    ),
                    onSaved: (value) => data['estado'] = value!,
                  ),
                ),
              ],
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Cidade",
                hintText: "Digite o nome da cidade",
              ),
              onSaved: (value) => data['cidade'] = value!,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Logradouro",
              ),
              onSaved: (value) => data['logradouro'] = value!,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Número",
              ),
              onSaved: (value) => data['numero'] = value!,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Complemento",
              ),
              onSaved: (value) => data['complemento'] = value!,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      widget._controller.previousPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                      );
                    },
                    child: const Text('Voltar'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (widget._formKey.currentState!.validate()) {
                        widget._formKey.currentState!.save();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Salvando dados, por favor aguarde.'),
                          ),
                        );
                        data["updatedAt"] = Timestamp.now();
                        _profileController.addData(data);
                      }
                    },
                    child: const Text('Enviar'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

// tela de criação de conta com nome, cpf, dt nascimento, email e senha
// colocar cpf e data de nascimento lado a lado

// restante das informações colocar na tela de edição de perfil
