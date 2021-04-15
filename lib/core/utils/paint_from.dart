import 'dart:ui';

Paint paintFrom(Paint paint) {
  return Paint()
    ..color = paint.color
    ..strokeWidth = paint.strokeWidth
    ..blendMode = paint.blendMode
    ..strokeCap = paint.strokeCap
    ..shader = paint.shader;
}
