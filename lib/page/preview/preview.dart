import 'dart:typed_data';
import 'package:ar_app/component/appbar_custom.dart';
import 'package:ar_app/component/btn_backward.dart';
import 'package:ar_app/component/btn_primary.dart';
import 'package:ar_app/component/btn_secondary.dart';
import 'package:ar_app/component/dialog_check.dart';
import 'package:ar_app/component/margin_for_btn.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter/material.dart';
import 'package:ar_app/constant/colors_constant.dart';
import 'package:share_plus/share_plus.dart';

class Preview extends StatelessWidget {
  const Preview({super.key, required this.capturedImage});
  final Uint8List capturedImage;

  Future<void> saveCapturedImage(
      Uint8List capturedImage, BuildContext context) async {
    try {
      await ImageGallerySaver.saveImage(capturedImage);
      String title = "完了";
      String content = "画像を保存しました";
      showCheckDialog(context, title, content);
    } catch (e) {
      String title = "エラー";
      String content = "画像の保存に失敗しました:$e";
      showCheckDialog(context, title, content);
    }
  }

  Future<void> shareCaptureImage(Uint8List capturedImage) async{
    try{
      XFile shareImage = XFile.fromData(
        capturedImage,
        mimeType:'image/png',
        name: 'share_image.png'
      );

      await Share.shareXFiles([shareImage],text: "#USJなう");
    }catch(e){
      print('共有中にエラーが発生:$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true, // AppBarの背後にbodyを拡張
        appBar: const AppBarCustom(
          leading: BtnBackward(),
        ),
        body: Expanded(
            child: Column(children: [
          Expanded(
            child: Container(color: ColorConstants.backgroundColorSub),
          ),
          Center(
              child: AspectRatio(
                  aspectRatio: 3 / 4,
                  child: Container(
                      color: ColorConstants.backgroundColorSub,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: Image.memory(
                              capturedImage,
                              fit: BoxFit.cover,
                              // width: double.infinity,
                            )),
                      )))),
          Expanded(
            child: Container(
                color: ColorConstants.backgroundColorSub,
                child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(children: [
                        BtnPrimary(
                            onPressed: () {
                              saveCapturedImage(capturedImage, context);
                            },
                            text: "写真を保存する"),
                        const MarginForBtn(),
                        BtnSecondary(
                            onPressed: () {
                              shareCaptureImage(capturedImage);
                            },
                            text: "SNSに共有する"),
                      ]),
                    ))),
          )
        ])));
  }
}
