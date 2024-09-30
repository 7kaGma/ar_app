import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:go_router/go_router.dart';
import 'package:ar_app/component/btn_howtouse.dart';
import 'package:ar_app/services/camera_permission.dart';

class QrReader extends StatefulWidget {
  const QrReader({super.key});

  @override
  State<QrReader> createState() => _QrReaderState();
}

class _QrReaderState extends State<QrReader> {
  // MobileScannerController
  final MobileScannerController controller = MobileScannerController(
    autoStart: false,// 自動で起動
    torchEnabled: false,// Flashライトのオンオフ
    useNewCameraSelector: true,//最新のカメラ機能を使うか
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

  Map<String,dynamic>? _translateBarcode(Barcode? barcode){
    final String? rawData = barcode?.displayValue;
    if(rawData != null){
      try{
        final Map<String,dynamic> editData = jsonDecode(rawData);
        return editData;
      }catch(e){
        print("JSON形式ではありません");
      }
    }  
    return null;
  }

  void controllScreenTranslation(Barcode? barcode,MobileScannerController controller){
    final editData = _translateBarcode(barcode);
    if(editData != null){
      if(editData["key"]=="seibu") {
        controller.stop();
        context.push('/waitingtime',extra:editData["value"]);
      }else{
        _barcode = null;
      }
    }else{
      _barcode = null;
    }
  }

  // init関数
  @override
  void initState() {
    super.initState();
    checkCameraPremission(context, controller, this);
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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("QR Reader"),
        actions: const [HowtouseBtn()],
      ),
      body:Stack(
        children: [
          Center(
            child:MobileScanner(
              controller: controller,
              fit: BoxFit.contain,
              // QRコードをスキャンしたら実行する関数
              onDetect: (scandata) {
                _handleBarcode(scandata);
                controllScreenTranslation(_barcode, controller);
              }
            ) 
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 100,
            ),
          )
        ],
      ) 
    );
  }
}