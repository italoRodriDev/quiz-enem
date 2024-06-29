class MateriaModel {
  String id;
  String nome;

  MateriaModel({required this.id, required this.nome});

  factory MateriaModel.fromJson(Map<String, dynamic> json) {
    return MateriaModel(id: json['id'] ?? '', nome: json['nome'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
    };
  }
}
