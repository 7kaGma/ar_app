import 'dart:typed_data';
import 'package:ar_app/page/howtouse.dart';
import 'package:go_router/go_router.dart';
import 'package:ar_app/page/home.dart';
import 'package:ar_app/page/webpage.dart';
import 'package:ar_app/page/qr_reader.dart';
import 'package:ar_app/page/waitingtime.dart';
import 'package:ar_app/page/arcamera.dart';
import 'package:ar_app/page/preview.dart';

final goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // Home
    GoRoute(
      path: '/',
      name:'home',
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
                return Waitingtime(value:value);
              } ,
              routes: [
                 // arcamera
                GoRoute(
                  path: 'arcamera',
                  name: 'arcamera',
                  builder: (context, state)=> const Arcamera(),
                  routes: [
                    // preview
                    GoRoute(
                      path: 'preview',
                      name: 'preview',
                      builder: (context, state) {
                        final capturedImage = state.extra as Uint8List;
                        return Preview(capturedImage:capturedImage);
                      },
                    ),
                  ]
                ),
              ]
            ),
          ]
        ),
      ]
    ),
    
    /*==========
    サブページ
    ==========*/
    // Webpage
    GoRoute(
      path: '/webpage',
      name: 'webpage',
      builder: (context, state) => const Webpage(),
    ),
    // howtouse
    GoRoute(
      path: '/howtouse',
      name: 'howtouse',
      builder: (context, state) => const Howtouse(),
    )
  ],
);
