import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tg/auth_controller.dart';
import 'package:tg/controllers/profile_controller.dart';
import 'package:tg/views/home_page.dart';

class MeuPerfil extends StatefulWidget {
  const MeuPerfil({Key? key, required this.tipoUsuario}) : super(key: key);
  final String tipoUsuario;

  @override
  State<MeuPerfil> createState() => _MeuPerfilState();
}

class _MeuPerfilState extends State<MeuPerfil> {
  Map<String, dynamic>? data;
  final ProfileController _profileController = Get.put(ProfileController());
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _profileController.getData().then((val) {
        setState(() {
          data = val;
          data!.forEach((key, value) {
            if (value == "") {
              data![key] = key;
            }
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text("Confira ou altere suas informações!"),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Nome",
                  hintText: "Seu nome de usuário",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O campo é obrigatório.';
                  }
                  return null;
                },
                onSaved: (value) => data!['nome'] = value!,
                key: Key(data?["nome"] ?? "nome"),
                initialValue: data?["nome"],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: "CPF",
                        hintText: "000.000.000-00",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'O campo é obrigatório.';
                        }
                        return null;
                      },
                      //onSaved: (value) => data["cpf"] = value!,
                      key: Key(data?["cpf"] ?? "cpf"),
                      initialValue: data?["cpf"],
                      readOnly: true,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.datetime,
                      decoration: const InputDecoration(
                        labelText: "Nascimento",
                        hintText: "dd/mm/yyyy",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'O campo é obrigatório.';
                        }
                        return null;
                      },
                      onSaved: (value) => data!["dataDeNascimento"] = value!,
                      key: Key(data?["dataDeNascimento"] ?? "dataDeNascimento"),
                      initialValue: data?["dataDeNascimento"],
                    ),
                  )
                ],
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "E-mail",
                ),
                key: Key(data?["email"] ?? "email"),
                initialValue: data?["email"],
                readOnly: true,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Telefone (fixo ou celular)",
                  hintText: "+00 (00) 99999-9999",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'O campo é obrigatório.';
                  }
                  return null;
                },
                onSaved: (value) => data!['telefone'] = value!,
                key: Key(data?["telefone"] ?? "telefone"),
                initialValue: data?["telefone"],
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
                      onSaved: (value) => data!['cep'] = value!,
                      key: Key(data?["cep"] ?? "cep"),
                      initialValue: data?["cep"],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Estado",
                        hintText: "Estado - UF",
                      ),
                      onSaved: (value) => data!['estado'] = value!,
                      key: Key(data?["estado"] ?? "estado"),
                      initialValue: data?["estado"],
                    ),
                  ),
                ],
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Cidade",
                  hintText: "Digite o nome da cidade",
                ),
                onSaved: (value) => data!['cidade'] = value!,
                key: Key(data?["cidade"] ?? "cidade"),
                initialValue: data?["cidade"],
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Logradouro",
                ),
                onSaved: (value) => data!['logradouro'] = value!,
                key: Key(data?["logradouro"] ?? "logradouro"),
                initialValue: data?["logradouro"],
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Número",
                ),
                onSaved: (value) => data!['numero'] = value!,
                key: Key(data?["numero"] ?? "numero"),
                initialValue: data?["numero"],
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Complemento",
                ),
                onSaved: (value) => data!['complemento'] = value!,
                key: Key(data?["complemento"] ?? "complemento"),
                initialValue: data?["complemento"],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () {
                    var novoPerfil = widget.tipoUsuario == "prestador"
                        ? "cliente"
                        : "prestador";
                    if (data!["tipoUsuario"].contains("cliente") &&
                        data!["tipoUsuario"].contains("prestador")) {
                      Get.offAll(() => HomePage(tipoUsuario: novoPerfil));
                    } else {
                      data!["tipoUsuario"].add(novoPerfil);
                      var newData = {
                        "updatedAt": Timestamp.now(),
                        "tipoUsuario": data!["tipoUsuario"],
                      };
                      _profileController.addData(newData);
                      Get.offAll(() => HomePage(tipoUsuario: novoPerfil));
                    }
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Trocar para ',
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        widget.tipoUsuario == "prestador"
                            ? const TextSpan(
                                text: 'cliente',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline),
                              )
                            : const TextSpan(
                                text: 'prestador de serviços',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline),
                              ),
                        const TextSpan(text: '!'),
                      ],
                    ),
                  ),
                ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () => AuthController.instance.logOut(),
                    child: const Text('Sair'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Atualizando dados, por favor aguarde.'),
                          ),
                        );
                        data!["updatedAt"] = Timestamp.now();
                        _profileController.addData(data!);
                      }
                    },
                    child: const Text('Atualizar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }
}
