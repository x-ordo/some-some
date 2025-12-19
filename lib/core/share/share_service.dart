import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ShareService {
  static Future<void> shareRepaintBoundary({
    required RenderRepaintBoundary boundary,
    String filename = 'thumb_some.png',
    String? text,
    double pixelRatio = 3.0,
  }) async {
    final ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return;

    final Uint8List pngBytes = byteData.buffer.asUint8List();
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(pngBytes, flush: true);

    await Share.shareXFiles([XFile(file.path)], text: text);
  }
}
