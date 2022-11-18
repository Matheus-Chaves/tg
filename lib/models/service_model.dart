import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceModel {
  late String cpfPrestador;
  late String categoria;
  late String descricao;
  late double valorMinimo;
  late String uid;
  late Timestamp dataCadastro;
  late String? id;
  late Timestamp? dataAtualizacao;

  ServiceModel(this.cpfPrestador, this.categoria, this.descricao,
      this.valorMinimo, this.uid, this.dataCadastro,
      {this.id, this.dataAtualizacao});

  ServiceModel.fromDocumentSnapshot({required DocumentSnapshot docSnapshot}) {
    cpfPrestador = docSnapshot['cpfPrestador'];
    categoria = docSnapshot['categoria'];
    descricao = docSnapshot['descricao'];
    valorMinimo = docSnapshot['valorMinimo'];
    uid = docSnapshot['uid'];
    dataCadastro = docSnapshot['dataCadastro'];
    id = docSnapshot.id;
    try {
      dataAtualizacao = docSnapshot['dataAtualizacao'];
    } catch (e) {
      dataAtualizacao = docSnapshot['dataCadastro'];
    }
  }

  Map<String, dynamic> toJson() => {
        "cpfPrestador": cpfPrestador,
        "categoria": categoria,
        "descricao": descricao,
        "valorMinimo": valorMinimo,
        "uid": uid,
        "dataCadastro": dataCadastro,
        "dataAtualizacao": dataAtualizacao,
      };
}
