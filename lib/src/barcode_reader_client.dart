import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class BarcodeReaderClient {
  BarcodeReaderClient();

  String? _barcode;

  String? getBarcode() {
    return _barcode;
  }

  void setBarcode(String value) {
    _barcode = value;
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      log(barcodeScanRes);

      setBarcode(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
  }
}