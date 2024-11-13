import 'dart:async';
import 'dart:convert';
import 'package:ar_app/component/appbar_custom.dart';
import 'package:ar_app/component/btn_backward.dart';
import 'package:ar_app/constant/colors_constant.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:go_router/go_router.dart';
import 'package:ar_app/utils/camera_permission.dart';

class QrReader extends StatefulWidget {
  const QrReader({super.key});

  @override
  State<QrReader> createState() => _QrReaderState();
}

class _QrReaderState extends State<QrReader> {
  // MobileScannerController
  final MobileScannerController controller = MobileScannerController(
    autoStart: false, // 自動で起動
    torchEnabled: false, // Flashライトのオンオフ
    useNewCameraSelector: true, //最新のカメラ機能を使うか
  );

  //変数_barcode
  Barcode? _barcode;

  void _handleBarcode(BarcodeCapture barcodes) {
    if (mounted) {
      setState(() {
        _barcode = barcodes.barcodes.firstOrNull;
      });
    }
  }

  Map<String, dynamic>? _translateBarcode(Barcode? barcode) {
    final String? rawData = barcode?.displayValue;
    if (rawData != null) {
      try {
        final Map<String, dynamic> editData = jsonDecode(rawData);
        return editData;
      } catch (e) {
        print("JSON形式ではありません");
      }
    }
    return null;
  }

  void controllScreenTranslation(
      Barcode? barcode, MobileScannerController controller) {
    final editData = _translateBarcode(barcode);
    if (editData != null && editData.containsKey("value")) {
      if (editData["key"] == "usj") {
        controller.stop();
        context.push('/qrreader/waitingtime', extra: editData["value"]);
      } else {
        _barcode = null;
      }
    } else {
      _barcode = null;
    }
  }

  void initializedMobileScanner(MobileScannerController controller){
    controller.start();
  }

  // init関数
  @override
  void initState() {
    super.initState();
    cameraPermission(context,this,()=>initializedMobileScanner(controller));
  }

  //dispose関数
  @override
  Future<void> dispose() async {
    _barcode = null;
    super.dispose();
    await controller.dispose();
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true, // AppBarの背後にbodyを拡張
        appBar: const AppBarCustom(
          leading:  BtnBackward(),
        ),
        body: Stack(
          children: [
            MobileScanner(
                controller: controller,
                // QRコードをスキャンしたら実行する関数
                onDetect: (scandata) {
                  _handleBarcode(scandata);
                  controllScreenTranslation(_barcode, controller);
                }),
            
            Positioned.fill(
                child: Column(
              children: [
                Expanded(
                  child: Container(
                    color: ColorConstants.backgroundColorSub 
                  ),
                ),
                Center(
                  child:AspectRatio(
                  aspectRatio: 3 /4 ,
                  child: Container(), 
                )),
                Expanded(
                  child: Container(
                    color: ColorConstants.backgroundColorSub,
                    child: const Center(
                      child: Text(
                        '入口のQRコードを読み込んでください',
                        style: TextStyle(
                          color:ColorConstants.fontColor,
                          fontSize: 16
                        ),
                      ),
                    ),

                  ),
                )
              ],
            ))
          ],
        ));
  }
}
