import 'dart:ui';

extension JsonParsingColor on Color {
  Map<String, dynamic> toMap() {
    return {
      'r': this.red,
      'g': this.green,
      'b': this.blue,
      'a': this.alpha,
    };
  }

  static Color fromMap(Map<String, dynamic> map) {
    return Color.fromARGB(map['a'], map['r'], map['g'], map['b']);
  }
}
