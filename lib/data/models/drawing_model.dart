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
    return DrawingModel(
      canvasPaths: map['canvasPaths'],
      sketchId: map['sketchId'],
      id: map['id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'canvasPaths':
          this.canvasPaths.map((e) => (e as CanvasPathModel).toMap()),
      'sketchId': this.sketchId,
      'id': this.id,
    };
  }
}
