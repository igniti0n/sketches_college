import '../../domain/entities/drawing.dart';
import '../../domain/entities/sketch.dart';

class SketchModel extends Sketch {
  SketchModel(
      {required String sketchName,
      required List<Drawing> drawings,
      required String id})
      : super(
          sketchName: sketchName,
          drawings: drawings,
          id: id,
        );

  factory SketchModel.fromJson(Map<String, dynamic> map, {String? id}) {
    return SketchModel(
      sketchName: map['sketchName'],
      drawings: [],
      id: id ?? map['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sketchName': this.sketchName,
      //'drawings': this.drawings,
      'id': this.id,
    };
  }
}
