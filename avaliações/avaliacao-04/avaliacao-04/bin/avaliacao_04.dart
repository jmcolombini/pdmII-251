import 'dart:io';
import 'package:sqlite3/sqlite3.dart';

void main() {
  // Abrir/criar o banco de dados local
  final db = sqlite3.open('alunos.db');

  // Criar a tabela TB_ALUNO
  db.execute('''
    CREATE TABLE IF NOT EXISTS TB_ALUNO (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL
    );
  ''');

  while (true) {
    print('\nEscolha uma opção:');
    print('1 - Inserir aluno');
    print('2 - Listar alunos');
    print('0 - Sair');
    
    String? escolha = stdin.readLineSync();

    if (escolha == '1') {
      inserirAluno(db);
    } else if (escolha == '2') {
      listarAlunos(db);
    } else if (escolha == '0') {
      print('Saindo...');
      break;
    } else {
      print('Opção inválida.');
    }
  }

  db.dispose();
}

void inserirAluno(Database db) {
  print('Digite o nome do aluno (máx 50 caracteres):');
  String? nome = stdin.readLineSync();

  if (nome != null && nome.length <= 50) {
    final stmt = db.prepare('INSERT INTO TB_ALUNO (nome) VALUES (?);');
    stmt.execute([nome]);
    stmt.dispose();
    print('Aluno inserido com sucesso!');
  } else {
    print('Nome inválido ou muito grande.');
  }
}

void listarAlunos(Database db) {
  final ResultSet resultSet = db.select('SELECT * FROM TB_ALUNO;');

  print('\n--- Lista de Alunos ---');
  for (final row in resultSet) {
    print('ID: ${row['id']} | Nome: ${row['nome']}');
  }
}
