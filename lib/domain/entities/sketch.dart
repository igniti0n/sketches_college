import 'package:equatable/equatable.dart';

import 'drawing.dart';

class Sketch extends Equatable {
  final String sketchName;
  final String id;
  final List<Drawing> drawings;
  const Sketch({
    required this.drawings,
    required this.id,
    required this.sketchName,
  });

  @override
  List<Object?> get props => [id, sketchName, drawings];

  @override
  String toString() =>
      'Name: $sketchName, id: $id, number of drawings: ${drawings.length}';
}
