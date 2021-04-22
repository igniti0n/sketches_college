import 'dart:ui';

extension JsonParsingPaint on Paint {
  Map<String, dynamic> toMap() {
    return {
      'strokeWidth': this.strokeWidth,
      'color': this.color,
      'blendMode': this.blendMode,
    };
  }

  static Paint fromMap(Map<String, dynamic> map) {
    return Paint()
      ..color = map['color']
      ..strokeWidth = map['strokeWidth']
      ..blendMode = map['blendMode'];
  }
}
