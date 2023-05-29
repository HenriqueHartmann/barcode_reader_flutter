import 'dart:developer';

import 'package:flutter/services.dart';

class MethodChannelClient {
  MethodChannelClient();

  final methodChannel = const MethodChannel('barcode.reader.flutter.channel');

  Future<void> sendBarcode({String? value = ''}) async {
    try {
      bool success = await methodChannel.invokeMethod(
        'sendBarcode',
        {
          'barcode': value ?? '',
        },
      );

      if (success) {
        log('SUCCESS: A mensagem foi enviado com sucesso');
      } else {
        log('FAILURE: Houve uma falha ao enviar a mensagem');
      }
    } catch (e) {
      log('ERROR: Não foi possível enviar a mensagem', error: e);
    }
  }
}