import 'dart:ui';

import 'color_extension.dart';

extension JsonParsingPaint on Paint {
  Map<String, dynamic> toMap() {
    return {
      'strokeWidth': this.strokeWidth,
      'color': JsonParsingColor(this.color).toMap(),
      'blendMode': this.blendMode.index,
    };
  }

  static Paint fromMap(Map<String, dynamic> map) {
    return Paint()
      ..color = JsonParsingColor.fromMap(map['color'])
      ..strokeWidth = map['strokeWidth']
      ..blendMode = BlendMode.values[map['blendMode']];
  }
}
