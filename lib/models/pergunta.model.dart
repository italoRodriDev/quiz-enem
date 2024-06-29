class PerguntaModel {
  String id;
  String idMateria;
  String materia;
  String idAssunto;
  String assunto;
  String pergunta;
  List<dynamic> alternativas;
  String respostaCorreta;

  PerguntaModel(
      {required this.id,
      required this.idMateria,
      required this.materia,
      required this.idAssunto,
      required this.assunto,
      required this.pergunta,
      required this.alternativas,
      required this.respostaCorreta});

  factory PerguntaModel.fromJson(Map<String, dynamic> json) {
    return PerguntaModel(
        id: json['id'] ?? '',
        idMateria: json['idMateria'] ?? '',
        materia: json['materia'] ?? '',
        idAssunto: json['idAssunto'] ?? '',
        assunto: json['assunto'] ?? '',
        pergunta: json['pergunta'] ?? '',
        alternativas: json['alternativas'] ?? [],
        respostaCorreta: json['respostaCorreta'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'idMateria': idMateria,
      'materia': materia,
      'idAssunto': idAssunto,
      'assunto': assunto,
      'pergunta': pergunta,
      'alternativas': alternativas,
      'respostaCorreta': respostaCorreta
    };
  }
}
