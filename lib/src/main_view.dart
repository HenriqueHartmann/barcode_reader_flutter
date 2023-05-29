import 'package:barcode_reader_flutter/src/barcode_reader_client.dart';
import 'package:barcode_reader_flutter/src/loading_controller.dart';
import 'package:barcode_reader_flutter/src/method_channel_client.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final barCodeEC = TextEditingController();
  final loadingController = LoadingController();
  final barCodeReaderClient = BarcodeReaderClient();
  final methodChannelClient = MethodChannelClient();

  bool editSwitch = false;

  @override
  void initState() {
    super.initState();

    barCodeReaderClient.scanBarcodeNormal().then(
          (value) {
        setState(() {
          loadingController.setIsLoading(value: false);
          barCodeEC.text = barCodeReaderClient.getBarcode() ?? '';
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();

    barCodeEC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const appColorPrimary = Colors.black;
    const appColorDisable = Colors.grey;
    var size = MediaQuery.of(context).size;
    var width = size.width;

    return WillPopScope(
      onWillPop: () async {
        await methodChannelClient.sendBarcode();

        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: const Text(
            'Leitor de código de barras',
            style: TextStyle(
              color: appColorPrimary,
            ),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () async {
              await methodChannelClient.sendBarcode();
            },
          ),
        ),
        body: Container(
          margin: const EdgeInsets.all(16.0),
          child: Builder(
            builder: (context) {
              if (loadingController.getIsLoading()) {
                return Column(
                  children: const [
                    Expanded(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  ],
                );
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 0,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 64.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                setState(() {
                                  loadingController.setIsLoading(value: true);
                                });

                                barCodeReaderClient.scanBarcodeNormal().then((value) {
                                  loadingController.setIsLoading(value: false);
                                  barCodeEC.text =
                                      barCodeReaderClient.getBarcode() ?? '';
                                  setState(() {});
                                });
                              },
                              icon: const Icon(
                                FontAwesomeIcons.barcode,
                                size: 24.0,
                                color: appColorPrimary,
                              ),
                              label: const Text(
                                'Ler novamente',
                                style: TextStyle(color: appColorPrimary),
                              ),
                            ),
                            Row(
                              children: [
                                const Text('Editar'),
                                Switch(
                                  value: editSwitch,
                                  onChanged: (bool value) {
                                    setState(() {
                                      editSwitch = value;
                                    });
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 64.0),
                            child: TextField(
                              enabled: editSwitch,
                              controller: barCodeEC,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 2.0,
                                    color: appColorPrimary,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 2.0,
                                    color: appColorPrimary,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                    width: 1.0,
                                    color: appColorDisable,
                                  ),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              onChanged: (value) {
                                barCodeReaderClient.setBarcode(value);
                              },
                            ),
                          ),
                          const Text(
                            'Valor do código de barras:',
                            textScaleFactor: 1.0,
                          ),
                          const SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  barCodeReaderClient.getBarcode() ?? '',
                                  textScaleFactor: 1.7,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await methodChannelClient
                            .sendBarcode(value: barCodeReaderClient.getBarcode());
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(
                          width,
                          width / 8 < 56.0 ? 56.0 : width / 8,
                        ),
                        backgroundColor: appColorPrimary,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 2,
                            color: appColorPrimary,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text(
                        'Confirmar',
                        textScaleFactor: 1.3,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
