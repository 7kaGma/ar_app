import 'dart:typed_data';
import 'package:go_router/go_router.dart';
import 'package:ar_app/page/home/home.dart';
import 'package:ar_app/page/webPage/webpage.dart';
import 'package:ar_app/page/qr_reader/qr_reader.dart';
import 'package:ar_app/page/waitingtime/waitingtime.dart';
import 'package:ar_app/page/arcamera/arcamera.dart';
import 'package:ar_app/page/preview/preview.dart';

final goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // Home
    GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const Home(),
        routes: [
          // QRReader
          GoRoute(
              path: 'qrreader',
              name: 'qrreader',
              builder: (context, state) => const QrReader(),
              routes: [
                // waitingtime
                GoRoute(
                    path: 'waitingtime',
                    name: 'waitingtime',
                    builder: (context, state) {
                      final value = state.extra as String;
                      return Waitingtime(value: value);
                    },
                    routes: [
                      // arcamera
                      GoRoute(
                          path: 'arcamera',
                          name: 'arcamera',
                          builder: (context, state) {
                            final extras = state.extra as Map<String, dynamic>;
                            // extrasから各値を取得
                            final stageNumber = extras['stageNumber'] as int;
                            final sceneNumber = extras['sceneNumber'] as String;

                            // Arcameraウィジェットに値を渡して返す
                            return Arcamera(
                                stageNumber: stageNumber,
                                sceneNumber: sceneNumber);
                          },
                          routes: [
                            // preview
                            GoRoute(
                              path: 'preview',
                              name: 'preview',
                              builder: (context, state) {
                                final capturedImage = state.extra as Uint8List;
                                return Preview(capturedImage: capturedImage);
                              },
                            ),
                          ]),
                    ]),
              ]),
        ]),

    /*==========
    サブページ
    ==========*/
    // Webpage
    GoRoute(
      path: '/webpage',
      name: 'webpage',
      builder: (context, state) => const Webpage(),
    )
  ],
);
