import 'dart:convert';

import '../../domain/entities/drawing.dart';
import 'canvas_path_model.dart';

// ignore: must_be_immutable
class DrawingModel extends Drawing {
  DrawingModel({
    required List<CanvasPathModel> canvasPaths,
    required String sketchId,
    required String id,
  }) : super(
          canvasPaths: canvasPaths,
          sketchId: sketchId,
          id: id,
        );

  factory DrawingModel.fromJson(Map<String, dynamic> map) {
    // log(map['canvasPaths'].toString());
    return DrawingModel(
      canvasPaths: (jsonDecode(map['canvasPaths']) as List<dynamic>)
          .map((e) => CanvasPathModel.fromMap(e))
          .toList(),
      sketchId: map['sketchId'],
      id: map['id'],
    );
  }

  Map<String, dynamic> toMap() {
    final res = jsonEncode(
        this.canvasPaths.map((e) => (e as CanvasPathModel).toMap()).toList());
    // log('toMap: ' + res);
    // log('length: ' + this.canvasPaths.length.toString());
    return {
      'canvasPaths': res,
      'sketchId': this.sketchId,
      'id': this.id,
    };
  }
}
