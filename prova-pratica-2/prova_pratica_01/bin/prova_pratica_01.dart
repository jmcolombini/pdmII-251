import 'package:prova_pratica_01/prova_pratica_01.dart' as prova_pratica_01;
import 'dart:convert';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mailer/smtp_server/gmail.dart';

class Disciplina {
  int id;
  String descricao;
  int qtdAulas;

  Disciplina({
    required this.id,
    required this.descricao,
    required this.qtdAulas
  });

  Map<String, dynamic> toJson() => {
    "id": id,
    "descricao": descricao,
    "qtdAulas": qtdAulas
  };
}

class Aluno {
  int id;
  String nome;
  String matricula;

  Aluno({
    required this.id,
    required this.nome,
    required this.matricula
  });

  Map<String, dynamic> toJson() => {
    "id": id,
    "nome": nome,
    "matricula": matricula
  };
}

class Professor {
  int id;
  String codigo;
  String nome;
  List<Disciplina> disciplinas;

  Professor({
    required this.id,
    required this.codigo,
    required this.nome,
    List<Disciplina>? disciplinas
  }) : disciplinas = disciplinas ?? [];
  
  void adicionarDisciplina(Disciplina disciplina) {
    disciplinas.add(disciplina);
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "codigo": codigo,
    "nome": nome,
    "disciplinas": disciplinas.map((item) => item.toJson()).toList()
  };
}

class Curso {
  int id;
  String descricao;
  List<Professor> professores;
  List<Disciplina> disciplinas;
  List<Aluno> alunos;

  Curso({
    required this.id,
    required this.descricao
  }) : professores = [],
        disciplinas = [],
        alunos = [];

  void adicionarProfessor(Professor professor) {
    professores.add(professor);
  }

  void adicionarDisciplina(Disciplina disciplina) {
    disciplinas.add(disciplina);
  }

  void adicionarAluno(Aluno aluno) {
    alunos.add(aluno);
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "descricao": descricao,
    "professores": professores.map((item) => item.toJson()).toList(),
    "disciplinas": disciplinas.map((item) => item.toJson()).toList(),
    "alunos": alunos.map((item) => item.toJson()).toList()
  };

}

void sendEmail({
  required String nomeRemetente,
  required String emailRemetente,
  required String senhaRemetente,
  required String emailDestinatario,
  required String assuntoEmail,
  required String conteudoEmail,
  required int quantidadeEnvios,
}) async {
  final smtpServer = gmail(emailRemetente, senhaRemetente);

  final message = Message()
  ..from = Address(emailRemetente, nomeRemetente)
  ..recipients.add(emailDestinatario)
  ..subject = assuntoEmail
  ..text = conteudoEmail;

  try{
    for (int i = 1; i <= quantidadeEnvios; i++){
      final result = await send(message, smtpServer);
      print('E-mail enviado: $result');
    }
  } on MailerException catch (err) {
    print('Erro ao enviar e-mail: ${err.toString()}');
  }
}

void main(List<String> arguments) {
  Disciplina pdmII = Disciplina(id: 1, descricao: "Desenvolvimento Mobile com Dart e Flutter.", qtdAulas: 80);
  Disciplina portV = Disciplina(id: 2, descricao: "Redação", qtdAulas: 40);

  Aluno a1 = Aluno(id: 1, nome: "João Marcelo", matricula: "20231011060141");
  Aluno a2 = Aluno(id: 2, nome: "Raúl Simioni", matricula: "20231011060000");

  Professor p1 = Professor(id: 1, codigo: "a1", nome: "Ricardo Duarte Taveira");
  Professor p2 = Professor(id: 2, codigo: "c2", nome: "Eugênia Tavares");

  p1.adicionarDisciplina(pdmII);
  p2.adicionarDisciplina(portV);

  Curso informatica = Curso(id: 1, descricao: "Curso técnico dedicado ao aprendizado de tecnologias que envolvem o campo computacional.");

  informatica.adicionarDisciplina(pdmII);
  informatica.adicionarDisciplina(portV);

  informatica.adicionarAluno(a1);
  informatica.adicionarAluno(a2);

  informatica.adicionarProfessor(p1);

  String cursoJSON = jsonEncode(informatica);

  print(cursoJSON);

  sendEmail(nomeRemetente: "Marcelo Colombini", emailRemetente: "jmccardonha2@gmail.com", senhaRemetente: "klly wank pngn fcqu", emailDestinatario: "taveira@ifce.edu.br", assuntoEmail: "Envio do JSON - Pedido 0001", conteudoEmail: cursoJSON, quantidadeEnvios: 1);



}
