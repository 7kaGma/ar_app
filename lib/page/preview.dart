import 'dart:typed_data';
import 'package:ar_app/component/check_dialog.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter/material.dart';

class Preview extends StatelessWidget {
  const Preview({super.key,required this.capturedImage});
  final Uint8List capturedImage;

  Future<void> saveCapturedImage(Uint8List capturedImage,BuildContext context) async{
    try{
      await ImageGallerySaver.saveImage(capturedImage);
      String title ="完了";
      String content="画像を保存しました";
      showCheckDialog(context, title, content);

    }catch (e){
      String title ="エラー";
      String content="画像の保存に失敗しました:$e";
      showCheckDialog(context, title, content);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Image.memory(
                capturedImage,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  saveCapturedImage(capturedImage, context);
                },
                icon: const Icon(Icons.save),
                label: const Text('保存する'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  backgroundColor: Colors.green,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text('戻る'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  backgroundColor: Colors.redAccent,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    );
  }
}