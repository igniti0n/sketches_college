import 'dart:ui';

import 'package:paint_app/core/extensions/offset_extension.dart';
import 'package:paint_app/core/extensions/paint_extension.dart';
import 'package:paint_app/domain/entities/canvas_path.dart';

class CanvasPathModel extends CanvasPath {
  CanvasPathModel({required List<Offset> drawPoints, required Paint paint})
      : super(
          drawPoints: drawPoints,
          paint: paint,
        );

  factory CanvasPathModel.fromMap(Map<String, dynamic> map) {
    return CanvasPathModel(
      drawPoints: (map['drawPoints'] as List<Map<String, dynamic>>)
          .map((offsetMap) => JsonParsing.fromMap(offsetMap))
          .toList(),
      paint: JsonParsingPaint.fromMap(map['paint']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'drawPoints': this.drawPoints.map((e) => e.toMap()).toList(),
      'paint': JsonParsingPaint(this.paint).toMap(),
    };
  }
}
