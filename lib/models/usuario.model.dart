class UsuarioModel {
  String id;
  String idUser;
  String nome;
  String email;
  String telefone;
  bool status;
  String typeUser;
  bool perfilCompleto;
  dynamic dataCadastro;

  UsuarioModel(
      {required this.id,
      required this.idUser,
      required this.nome,
      required this.email,
      required this.telefone,
      required this.status,
      required this.dataCadastro,
      required this.typeUser,
      required this.perfilCompleto});

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      id: json['id'] ?? '',
      idUser: json['idUser'] ?? '',
      nome: json['nome'] ?? '',
      email: json['email'] ?? '',
      telefone: json['telefone'] ?? '',
      status: json['status'] ?? false,
      perfilCompleto: json['perfilCompleto'] ?? false,
      typeUser: json['typeUser'] ?? 'TECNICO',
      dataCadastro: json['dataCadastro'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idUser': idUser,
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'status': status,
      'perfilCompleto': perfilCompleto,
      'typeUser': typeUser,
      'dataCadastro': dataCadastro
    };
  }
}
