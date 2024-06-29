class AssuntoModel {
  String id;
  String idMateria;
  String materia;
  String nome;

  AssuntoModel({required this.id, required this.idMateria,required this.materia, required this.nome});

  factory AssuntoModel.fromJson(Map<String, dynamic> json) {
    return AssuntoModel(
        id: json['id'] ?? '',
        idMateria: json['idMateria'] ?? '',
        materia: json['materia'] ?? '',
        nome: json['nome'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idMateria': idMateria,
      'materia': materia,
      'nome': nome,
    };
  }
}
