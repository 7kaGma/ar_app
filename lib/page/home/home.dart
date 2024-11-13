import 'package:ar_app/component/appbar_custom.dart';
import 'package:ar_app/component/margin_for_btn.dart';
import 'package:ar_app/component/btn_primary.dart';
import 'package:ar_app/component/btn_secondary.dart';
import 'package:ar_app/constant/colors_constant.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ar_app/component/btn_howtouse.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, 
      appBar: const AppBarCustom(
        actions: [BtnHowtouse()],
      ),
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                ColorConstants.backgroundColor,
                ColorConstants.backgroundColorGradietEnd
              ],
                  stops: [
                0.5,
                1
              ])),
          child: Padding(
              padding: const EdgeInsets.all(30),
              child: SafeArea(
                  child: Stack(
                children: [
                  Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                          padding: const EdgeInsets.only(top: 170),
                          child: Image.asset(
                            'assets/images/logo.png',
                            width: 200,
                            height: 200,
                          ))),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          BtnPrimary(
                              onPressed: () {
                                context.push('/qrreader');
                              },
                              text: "待機列に並ぶ"),
                          const MarginForBtn(),
                          BtnSecondary(
                              onPressed: () {
                                context.push('/webpage');
                              },
                              text: "USJ公式サイト"),
                          const SizedBox(
                            height: 70,
                          ),
                        ],
                      ))
                ],
              )))),
    );
  }
}
