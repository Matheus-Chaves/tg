class Usuario {
  // String cpf;
  String nome;
  //String status;
  String email;
  // String dataDeNascimento;
  // String avaliacao;
  // String cep;
  // String logradouro;
  // String cidade;
  // String numero;
  // String estado;
  // String complemento;
  // String telefone;
  String uid;

  // Usuario({
  //   required this.cpf,
  //   required this.nome,
  //   required this.status,
  //   required this.email,
  //   required this.dataDeNascimento,
  //   required this.avaliacao,
  //   required this.cep,
  //   required this.logradouro,
  //   required this.cidade,
  //   required this.numero,
  //   required this.estado,
  //   required this.complemento,
  //   required this.telefone,
  // });
  Usuario({
    required this.nome,
    required this.email,
    required this.uid,
  });

  Map<String, dynamic> toJson() => {
        "nome": nome,
        "email": email,
        "uid": uid,
        "createdAt": DateTime.now(),
        //"updatedAt": DateTime.now(),
      };
}


//colocar cpf, data de nascimento, telefone aqui

//informaçoes de endereço colocar como opcionais
