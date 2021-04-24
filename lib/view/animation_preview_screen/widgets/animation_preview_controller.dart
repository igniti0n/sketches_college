import 'dart:async';

import '../../../domain/entities/drawing.dart';

class AnimationPreviewController {
  Duration _frameDuration = Duration(milliseconds: 250);
  List<Drawing> _sketch;
  int _drawingToShow = 0;

  late Stream<Drawing> _drawingStream;
  AnimationPreviewController(this._sketch) {
    _drawingStream = Stream.periodic(_frameDuration, (_) {
      _drawingToShow++;
      if (_drawingToShow == _sketch.length) _drawingToShow = 0;
      return _sketch.elementAt(_drawingToShow);
    });
  }

  void setFrameDuration(Duration dur) {
    _drawingStream = Stream.periodic(dur, (_) {
      _drawingToShow++;
      if (_drawingToShow == _sketch.length) _drawingToShow = 0;
      return _sketch.elementAt(_drawingToShow);
    });
  }

  void setSkecth(List<Drawing> sketch) => _sketch = sketch;

  Stream<Drawing> generateFrameCall() => _drawingStream;
}
