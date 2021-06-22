import 'package:paint_app/data/datasources/database_source.dart';
import 'package:paint_app/data/models/sketch_model.dart';
import 'package:paint_app/data/models/drawing_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NetworkDataSource extends DatabaseSource {
  @override
  Future<void> addNewDrawing(DrawingModel newDrawing) async {
    await FirebaseFirestore.instance
        .collection('drawings')
        .add(newDrawing.toMap());
  }

  @override
  Future<void> addNewSketch(SketchModel newSketch) async {
    await FirebaseFirestore.instance
        .collection('sketches')
        .add(newSketch.toJson());
  }

  @override
  Future<int> deleteDrawing(String drawingId) async {
    await FirebaseFirestore.instance
        .collection('drawings')
        .doc(drawingId)
        .delete();
    return 1;
  }

  @override
  Future<void> deleteSketch(String sketchId) async {
    await FirebaseFirestore.instance
        .collection('sketches')
        .doc(sketchId)
        .delete();
  }

  @override
  Future<List<DrawingModel>> getDrawingsFromDatabase(String sketchId) async {
    final _docSnapshots =
        await FirebaseFirestore.instance.collection('drawings').get();

    final List<DrawingModel> _doc = _docSnapshots.docs
        .map((e) => DrawingModel.fromJson(e.data(), id: e.id))
        .toList();

    return _doc;
  }

  @override
  Future<List<SketchModel>> getSketchesFromDatabase() async {
    final _docSnapshots =
        await FirebaseFirestore.instance.collection('sketches').get();

    final List<SketchModel> _doc = _docSnapshots.docs
        .map((e) => SketchModel.fromJson(e.data(), id: e.id))
        .toList();

    return _doc;
  }

  @override
  Future<int> updateDrawing(DrawingModel updatedDrawing) async {
    try {
      await FirebaseFirestore.instance
          .collection('drawings')
          .doc(updatedDrawing.id)
          .update(updatedDrawing.toMap());
    } catch (err) {
      await FirebaseFirestore.instance
          .collection('drawings')
          .add(updatedDrawing.toMap());
    }

    return 1;
  }

  @override
  Future<int> updateSketch(SketchModel updatedSketch) async {
    try {
      await FirebaseFirestore.instance
          .collection('sketches')
          .doc(updatedSketch.id)
          .update(updatedSketch.toJson());
    } catch (err) {
      await FirebaseFirestore.instance
          .collection('sketches')
          .add(updatedSketch.toJson());
    }

    return 1;
  }
}
