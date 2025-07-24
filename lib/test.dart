import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  int num = 0;
  final drawingbox = GlobalKey();
  final imageKey = GlobalKey();

  final createdImagePath =
      '/data/user/0/com.example.noted_d/app_flutter/my_img.png';

  Future<Uint8List?> capturePng() async {
    try {
      final boundary =
          drawingbox.currentContext?.findRenderObject()
              as RenderRepaintBoundary;

      final image = await boundary.toImage(pixelRatio: 3);

      final byteData = await image.toByteData(format: ImageByteFormat.png);

      final dir = await getApplicationDocumentsDirectory();

      final imagePath = '${dir.path}/my_img.png';

      final File imagefile = File(imagePath);

      await imagefile.writeAsBytes(byteData!.buffer.asUint8List());
      log('widget coonverted Too image');
    } catch (err) {
      log(err.toString());
    }
    return null;
  }

  @override
  Widget build(final BuildContext context) {
    return Material(
      color: Colors.white,
      child: Center(
        child: Image.file(
          height: 500,
          width: 200,
          File(
            '/data/user/0/com.example.noted_d/app_flutter/6f6e7b07-91e5-40ec-88ec-f499523db04f.png',
          ),
        ),
      ),
    );
  }
}
