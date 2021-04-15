import 'package:equatable/equatable.dart';

import 'drawing.dart';

class AnimatedSketch extends Equatable {
  final List<Drawing> drawings;
  const AnimatedSketch({required this.drawings});

  @override
  List<Object?> get props => [drawings];
}
