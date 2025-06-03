import 'package:treino/treino.dart' as treino;
import 'dart:convert';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mailer/smtp_server/gmail.dart';

class Cliente {
  int codigo;
  String nome;
  int tipoCliente;

  Cliente({
    required this.codigo,
    required this.nome,
    required this.tipoCliente
  });

  Map<String, dynamic> toJson() => {
    "codigo": codigo,
    "nome": nome,
    "tipoCliente": tipoCliente
  };
}

class Vendedor {
  int codigo;
  String nome;
  double comissao;

  Vendedor({
    required this.codigo,
    required this.nome,
    required this.comissao
  });

  Map<String, dynamic> toJson() => {
    "codigo": codigo,
    "nome": nome,
    "comissao": comissao
  };
}

class Veiculo {
  int codigo;
  String descricao;
  double valor;

  Veiculo({
    required this.codigo,
    required this.descricao,
    required this.valor
  });

  Map<String, dynamic> toJson() => {
    "codigo": codigo,
    "descricao": descricao,
    "valor": valor
  };
}

class ItemPedido {
  int sequencial;
  String descricao;
  int quantidade;
  double valor;

  ItemPedido ({
    required this.sequencial,
    required this.descricao,
    required this.quantidade,
    required this.valor
  });

  Map<String, dynamic> toJson() => {
    "sequencial": sequencial,
    "descricao": descricao,
    "quantidade": quantidade,
    "valor": valor
  };
}

class PedidoVenda {
  int codigo;
  DateTime data;
  double valorPedido;
  Cliente cliente;
  Vendedor vendedor;
  Veiculo veiculo;
  List<ItemPedido> acessorios;

  PedidoVenda({
    required this.codigo,
    required this.data,
    this.valorPedido = 0.0,
    required this.cliente,
    required this.vendedor,
    required this.veiculo,
    required this.acessorios
  });

  double calcularPedido() {
    double valor = 0.0;
    for(var acessorio in acessorios) {
      valor = valor + (acessorio.valor * acessorio.quantidade);
    }
    valor = valor + veiculo.valor;

    return valor;
  }

  Map<String, dynamic> toJson() => {
    "codigo": codigo,
    "data": data.toIso8601String(),
    "valorPedido": valorPedido,
    "cliente": cliente.toJson(),
    "vendedor": vendedor.toJson(),
    "veiculo": veiculo.toJson(),
    "acessorios": acessorios.map((item) => item.toJson()).toList()
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
  Cliente cliente1 = Cliente(codigo: 1, nome: "José Penelope", tipoCliente: 1);
  Vendedor vendedor1 = Vendedor(codigo: 1, nome: "Ricardo Teixeira", comissao: 12.00);
  Veiculo lamborghini = Veiculo(codigo: 1, descricao: "Lamborghini Aventador", valor: 100000000.00);

  ItemPedido volante = ItemPedido(sequencial: 1, descricao: "Volante de couro", quantidade: 1, valor: 12000.00);
  ItemPedido farolLed = ItemPedido(sequencial: 2, descricao: "Farol com brilho intenso de Led", quantidade: 2, valor: 20000.00);

  PedidoVenda venda1 = PedidoVenda(codigo: 0001, data: DateTime.parse('1969-07-20 20:18:04Z'), cliente: cliente1, vendedor: vendedor1, veiculo: lamborghini, acessorios: [volante, farolLed]);
  venda1.valorPedido = venda1.calcularPedido();

  String pedidoVendaJSON = jsonEncode(venda1);

  sendEmail(nomeRemetente: "Marcelo Colombini", emailRemetente: "jmccardonha2@gmail.com", senhaRemetente: "klly wank pngn fcqu", emailDestinatario: "joao.marcelo62@aluno.ifce.edu.br", assuntoEmail: "Envio do JSON - Pedido 0001", conteudoEmail: pedidoVendaJSON, quantidadeEnvios: 1);
}

