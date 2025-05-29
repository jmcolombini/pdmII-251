import 'dart:io';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

main() async {
  // Configura as credenciais SMTP do Gmail
  final smtpServer = gmail('jmccardonha2@gmail.com', 'klly wank pngn fcqu');

  // Cria uma mensagem de e-mail
  final message =
      Message()
        ..from = Address(
          'jmccardonha2@gmail.com',
          'João Marcelo Colombini Cardonha',
        )
        ..recipients.add('joao.marcelo62@aluno.ifce.edu.br')
        ..subject = 'Teste SMTP dart'
        ..text = 'Essa mensagem é um teste da avaliação 05 de dart';

  try {
    // Envia o e-mail usando o servidor SMTP do Gmail
    final sendReport = await send(message, smtpServer);

    // Exibe o resultado do envio do e-mail
    print('E-mail enviado: ${sendReport}');
  } on MailerException catch (e) {
    // Exibe informações sobre erros de envio de e-mail
    print('Erro ao enviar e-mail: ${e.toString()}');
  }
}