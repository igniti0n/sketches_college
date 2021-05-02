import 'dart:developer';

import '../models/drawing_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/sketch_model.dart';

const String sketchTable = 'sketch';
const String drawingTable = 'drawing';

abstract class DatabaseSource {
  Future<void> addNewSketch(SketchModel newSketch);
  Future<int> updateSketch(SketchModel updatedSketch);
  Future<void> deleteSketch(String sketchId);
  Future<List<SketchModel>> getSketchesFromDatabase();

  Future<void> addNewDrawing(DrawingModel newDrawing);
  Future<int> updateDrawing(DrawingModel updatedDrawing);
  Future<int> deleteDrawing(String drawingId);
  Future<List<DrawingModel>> getDrawingsFromDatabase(String sketchId);
}

class DatabaseSourceImpl extends DatabaseSource {
  static Database? db;
  static final DatabaseSourceImpl dbSource = DatabaseSourceImpl._();
  DatabaseSourceImpl._();

  Future<Database> get database async {
    if (db == null) db = await _initDb();
    return db!;
  }

  _initDb() async {
    // //TODO:REMOVE FOR THE RELEASE
    // await deleteDatabase(join(await getDatabasesPath(), 'sketches.db'));fluzt
    return await openDatabase(
      join(await getDatabasesPath(), 'sketches.db'),
      onCreate: (db, version) async {
        await db.execute('''create table $sketchTable (
          id TEXT PRIMARY KEY,
          sketchName TEXT not null
          )
        ''');

        await db.execute('''
       create table $drawingTable (
       canvasPaths TEXT not null,
       sketchId TEXT not null,
       id TEXT not null
       )''');
      },
      version: 1,
    );
  }

//!sketches
  @override
  Future<void> addNewSketch(SketchModel newSketch) async {
    log(newSketch.toJson().toString());
    final db = await database;
    await db.insert(sketchTable, newSketch.toJson());
  }

  @override
  Future<int> deleteSketch(String sketchId) async {
    final db = await database;
    return await db.delete(sketchTable, where: 'id=?', whereArgs: [sketchId]);
  }

  @override
  Future<List<SketchModel>> getSketchesFromDatabase() async {
    final db = await database;
    final result = await db.query(sketchTable, orderBy: 'id ASC');
    // log('from DB:' + result.toString());
    return result
        .map((Map<String, Object?> sketch) => SketchModel.fromJson(sketch))
        .toList();
  }

  @override
  Future<int> updateSketch(SketchModel updatedSketch) async {
    final db = await database;
    return await db.update(sketchTable, updatedSketch.toJson(),
        where: 'id=?', whereArgs: [updatedSketch.id]);
  }

  //!drawings

  @override
  Future<void> addNewDrawing(DrawingModel newDrawing) async {
    // log('adding drawing:' + newDrawing.toMap().toString());
    final db = await database;
    await db.insert(drawingTable, newDrawing.toMap());
  }

  @override
  Future<int> deleteDrawing(String drawingId) async {
    final db = await database;
    return await db.delete(drawingTable, where: 'id=?', whereArgs: [drawingId]);
  }

  @override
  Future<List<DrawingModel>> getDrawingsFromDatabase(String sketchId) async {
    final db = await database;
    final result = await db
        .query(drawingTable, where: 'sketchId=?', whereArgs: [sketchId]);
    // log('query from db' + result.toString());
    final list = result.map((Map<String, Object?> drawing) {
      return DrawingModel.fromJson(drawing);
    }).toList();
    return list;
  }

  @override
  Future<int> updateDrawing(DrawingModel updatedDrawing) async {
    // log('updating drawing:' + updatedDrawing.toMap().toString());
    // log('drawing id:    ' + updatedDrawing.id.toString());
    final db = await database;
    return await db.update(
      drawingTable,
      updatedDrawing.toMap(),
      where: 'id=?',
      whereArgs: [updatedDrawing.id],
    );
  }
}
