import 'package:cloud_firestore/cloud_firestore.dart';

class RequestModel {
  late String solicitanteId;
  late String servicoId;
  late String descricao;
  late Timestamp dataSolicitacao;
  late String status;
  late String id;
  late String prestadorId;
  late String? statusPagamento;
  late double? valor;
  late String? observacao;
  late String? urlDownload;

  RequestModel(this.solicitanteId, this.servicoId, this.descricao,
      this.dataSolicitacao, this.status, this.id, this.prestadorId,
      {this.statusPagamento, this.valor, this.observacao, this.urlDownload});

  RequestModel.fromDocumentSnapshot({required DocumentSnapshot docSnapshot}) {
    solicitanteId = docSnapshot["solicitanteId"];
    servicoId = docSnapshot["servicoId"];
    descricao = docSnapshot["descricao"];
    dataSolicitacao = docSnapshot["dataSolicitacao"];
    status = docSnapshot["status"];
    id = docSnapshot["id"];
    prestadorId = docSnapshot["prestadorId"];
    statusPagamento = docSnapshot["statusPagamento"];
    valor = docSnapshot["valor"];
    observacao = docSnapshot["observacao"];
    urlDownload = docSnapshot["urlDownload"];
  }

  Map<String, dynamic> toJson() => {
        "solicitanteId": solicitanteId,
        "servicoId": servicoId,
        "descricao": descricao,
        "dataSolicitacao": dataSolicitacao,
        "status": status,
        "id": id,
        "prestadorId": prestadorId,
        "statusPagamento": statusPagamento,
        "valor": valor,
        "observacao": observacao,
      };
}
