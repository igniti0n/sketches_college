import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import '../error/failures.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart' as perm;

final GlobalKey globalKey = GlobalKey();

ByteData? imagePngBytes;
String? fileName;
Random random = Random();

Future<Either<Failure, File>> takeScreenshotAndSave() async {
  RenderRepaintBoundary? boundary =
      globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
  ui.Image? image = await boundary?.toImage();
  final directory = (await getApplicationDocumentsDirectory()).path;
  ByteData? byteData = await image?.toByteData(format: ui.ImageByteFormat.png);
  Uint8List? pngBytes = byteData?.buffer.asUint8List();
  print(pngBytes);

  imagePngBytes = byteData;

  String imageName = random.nextInt(200).toString();
  fileName = imageName;
  File imgFile = File('$directory/${random.nextInt(200)}.png');

  if (await _askPermission()) {
    final result =
        await ImageGallerySaver.saveImage(Uint8List.fromList(pngBytes!));
    print(result);
    imgFile.writeAsBytes(pngBytes);
    return Right(imgFile);
  }
  return Left(StorageFailure());
}

Future<bool> _askPermission() async {
  /*Map<PermissionGroup, PermissionStatus> permissions =
    */
  final res = await perm.Permission.storage.request();
  return res.isGranted;
}
