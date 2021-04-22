import 'package:paint_app/data/models/drawing_model.dart';
import 'package:paint_app/domain/entities/sketch.dart';
import 'package:paint_app/view/home_screen/sketches_bloc/sketches_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

abstract class DatabaseSource {
  Future<void> addNewSketch(Sketch newSketch);
  Future<void> updateSketch(Sketch updatedSketch);
  Future<void> deleteSketch(String sketchId);
  Future<List<Sketch>> getSketchesFromDatabase();
}

class DatabaseSourceImpl extends DatabaseSource {
  static Database? db;
  static final DatabaseSourceImpl dbSource = DatabaseSourceImpl._();
  DatabaseSourceImpl._();

  Future<Database> get database async {
    if (db == null) await _initDb();
    return db!;
  }

  _initDb() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'sketches.db'),
      onCreate: (db, version) async {
        await db.execute('''
          id TEXT PRIMARY KEY,
          sketchName TEXT,
        ''');

        await db.execute('''
        
        ''');
      },
      version: 1,
    );
  }

  @override
  Future<void> addNewSketch(Sketch newSketch) {
    // TODO: implement addNewSketch
    throw UnimplementedError();
  }

  @override
  Future<void> deleteSketch(String sketchId) {
    // TODO: implement deleteSketch
    throw UnimplementedError();
  }

  @override
  Future<List<Sketch>> getSketchesFromDatabase() {
    // TODO: implement getSketchesFromDatabase
    throw UnimplementedError();
  }

  @override
  Future<void> updateSketch(Sketch updatedSketch) {
    // TODO: implement updateSketch
    throw UnimplementedError();
  }
}
