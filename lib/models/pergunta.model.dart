

class PerguntaModel {
  String id;
  String materia;
  String assunto;
  String pergunta;
  List<dynamic> alternativas;
  String respostaCorreta;

  PerguntaModel(
      {required this.id,
      required this.materia,
      required this.assunto,
      required this.pergunta,
      required this.alternativas,
      required this.respostaCorreta});

  factory PerguntaModel.fromJson(Map<String, dynamic> json) {
    return PerguntaModel(
        id: json['id'] ?? '',
        materia: json['materia'] ?? '',
        assunto: json['assunto'] ?? '',
        pergunta: json['pergunta'] ?? '',
        alternativas: json['alternativas'] ?? [],
        respostaCorreta: json['respostaCorreta'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'materia': materia,
      'assunto': assunto,
      'pergunta': pergunta,
      'alternativas': alternativas,
      'respostaCorreta': respostaCorreta
    };
  }
}
