import 'dart:ui';

import '../../core/extensions/offset_extension.dart';
import '../../core/extensions/paint_extension.dart';
import '../../domain/entities/canvas_path.dart';

class CanvasPathModel extends CanvasPath {
  CanvasPathModel({required List<Offset> drawPoints, required Paint paint})
      : super(
          drawPoints: drawPoints,
          paint: paint,
        );

  factory CanvasPathModel.fromMap(Map<String, dynamic> map) {
    final _newCanvasPath = CanvasPathModel(
      drawPoints: (map['drawPoints'] as List<dynamic>)
          .map((offsetMap) => JsonParsing.fromMap(offsetMap))
          .toList(),
      paint: JsonParsingPaint.fromMap(map['paint']),
    );
    _newCanvasPath.createPathFromOffsets();
    return _newCanvasPath;
  }

  Map<String, dynamic> toMap() {
    return {
      'drawPoints': this.drawPoints.map((e) => e.toMap()).toList(),
      'paint': JsonParsingPaint(this.paint).toMap(),
    };
  }
}
