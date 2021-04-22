import 'dart:ui';

extension JsonParsing on Offset {
  Map<String, dynamic> toMap() {
    return {
      'dx': this.dx,
      'dy': this.dy,
    };
  }

  static Offset fromMap(Map<String, dynamic> map) {
    return Offset(map['dx'], map['dy']);
  }
}
