import 'dart:async';

import 'package:dartz/dartz.dart';
import '../../../domain/entities/drawing.dart';
import '../../../domain/entities/sketch.dart';

class AnimationPreviewController {
  Duration _frameDuration = Duration(milliseconds: 250);
  Sketch _sketch;
  int _drawingToShow = 0;

  late Stream<Drawing> _drawingStream;
  AnimationPreviewController(this._sketch) {
    _drawingStream = Stream.periodic(_frameDuration, (_) {
      _drawingToShow++;
      if (_drawingToShow == _sketch.drawings.length) _drawingToShow = 0;
      return _sketch.drawings.elementAt(_drawingToShow);
    });
  }

  void setFrameDuration(Duration dur) {
    _drawingStream = Stream.periodic(dur, (_) {
      _drawingToShow++;
      if (_drawingToShow == _sketch.drawings.length) _drawingToShow = 0;
      return _sketch.drawings.elementAt(_drawingToShow);
    });
  }

  void setSkecth(Sketch sketch) => _sketch = sketch;

  Stream<Drawing> generateFrameCall() => _drawingStream;
}
