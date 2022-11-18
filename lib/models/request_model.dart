import 'package:cloud_firestore/cloud_firestore.dart';

class RequestModel {
  late String solicitanteId;
  late String servicoId;
  late String descricao;
  late Timestamp dataSolicitacao;
  late String status;
  late String id;

  RequestModel(this.solicitanteId, this.servicoId, this.descricao,
      this.dataSolicitacao, this.status, this.id);

  RequestModel.fromDocumentSnapshot({required DocumentSnapshot docSnapshot}) {
    solicitanteId = docSnapshot["solicitanteId"];
    servicoId = docSnapshot["servicoId"];
    descricao = docSnapshot["descricao"];
    dataSolicitacao = docSnapshot["dataSolicitacao"];
    status = docSnapshot["status"];
    id = docSnapshot["id"];
  }

  Map<String, dynamic> toJson() => {
        "solicitanteId": solicitanteId,
        "servicoId": servicoId,
        "descricao": descricao,
        "dataSolicitacao": dataSolicitacao,
        "status": status,
        "id": id
      };
}
