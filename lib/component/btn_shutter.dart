import 'package:ar_app/constant/colors_constant.dart';
import 'package:flutter/material.dart';

class BtnShutter extends StatefulWidget {
  const BtnShutter({super.key, required this.size, required this.onPressed});
  final VoidCallback? onPressed;
  final double size;

  @override
  State<BtnShutter> createState() => _BtnShutterState();
}

class _BtnShutterState extends State<BtnShutter> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() {
          _isPressed = true;
        });
      },
      onTapUp: (_) {
        setState(() {
          _isPressed = false;
        });
      },
      onTapCancel: () {
        setState(() {
          _isPressed = false;
        });
      },
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 4),
        ),
        child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: ElevatedButton(
              onPressed: widget.onPressed,
              style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: EdgeInsets.zero,
                  backgroundColor: Colors.transparent),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // ElevatedButtonのサイズ（constraints.maxWidth）に基づいてAnimatedContainerの幅と高さを設定
                  double buttonSize = constraints.maxWidth;
                  return AnimatedContainer(
                    duration: const Duration(
                        milliseconds: 200), // マイクロ秒ではなくミリ秒に変更しました
                    curve: Curves.elasticOut,
                    width: _isPressed ? buttonSize * 0.8 : buttonSize,
                    height: _isPressed ? buttonSize * 0.8 : buttonSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isPressed
                          ? ColorConstants.primaryColor
                          : ColorConstants.frameColor,
                    ),
                  );
                },
              ),
            )),
      ),
    );
  }
}
