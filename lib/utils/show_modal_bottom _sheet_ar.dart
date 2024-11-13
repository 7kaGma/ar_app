import 'package:flutter/material.dart';
import 'package:ar_app/constant/colors_constant.dart';

class ModalBottomSheetAr extends StatefulWidget {
  const ModalBottomSheetAr({
    super.key,
    required this.title,
    required this.itemCount,
    required this.stageNumber,
    required this.clickFunction,
    required this.selectedButtonIndex,
  });

  final String title;
  final int itemCount;
  final int stageNumber;
  final Function(int) clickFunction; // ボタンごとに異なる挙動=>引数としてindexを取る関数
  final int selectedButtonIndex;

  @override
  State<ModalBottomSheetAr> createState() => _ModalBottomSheetArState();
}

class _ModalBottomSheetArState extends State<ModalBottomSheetAr> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * (2 / 5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  widget.title,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.only(top: 10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                  ),
                  itemCount: widget.itemCount,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: widget.stageNumber >= index
                          ? () {
                              widget.clickFunction(index);
                            }
                          : null,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: widget.selectedButtonIndex == index
                              ? Colors.black.withOpacity(0.4)
                              : Colors.grey.shade300,
                        ),
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            'STAGE${index + 1}',
                            style: TextStyle(
                              color: widget.stageNumber >= index
                                  ? ColorConstants.backgroundColor
                                  : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void showModalBottomSheetAr(
  BuildContext context,
  String title,
  int itemCount,
  int stageNumber,
  Function(int) clickFunction,
  int selectedButtonIndex,
) {
  showModalBottomSheet(
    context: context,
    builder: (context) => ModalBottomSheetAr(
      title: title,
      itemCount: itemCount,
      stageNumber: stageNumber,
      clickFunction: clickFunction,
      selectedButtonIndex: selectedButtonIndex,
    ),
  );
}
