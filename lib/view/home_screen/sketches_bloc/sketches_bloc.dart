import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../core/error/failures.dart';
import '../../../domain/entities/sketch.dart';
import '../../../domain/repositories/sketches_repository.dart';

part 'sketches_event.dart';
part 'sketches_state.dart';

const String ERROR_LOADING_SKETCHES = 'Error whiel loading your sketches.';
const String ERROR_ADDING_SKETCH = 'Error while adding new sketch.';

class SketchesBloc extends Bloc<SketchesEvent, SketchesState> {
  final SketchesRepository _sketchesRepository;
  SketchesBloc(this._sketchesRepository) : super(SketchesInitial([]));

  @override
  Stream<SketchesState> mapEventToState(
    SketchesEvent event,
  ) async* {
    if (event is FetchAllSketches) {
      yield LoadingSketches(_sketchesRepository.currentSketches);
      final either = await _sketchesRepository.getSketches();
      yield either.fold(
        (Failure failure) => Error(
          [],
          ERROR_LOADING_SKETCHES,
        ),
        (List<Sketch> sketches) => SketchesLoaded(sketches),
      );
    } else if (event is AddNewSketch) {
      yield LoadingSketches([]);
      final either = await _sketchesRepository.addNewSketch();
      yield either.fold(
        (Failure failure) => Error(
          [],
          ERROR_ADDING_SKETCH,
        ),
        (List<Sketch> sketches) => SketchesLoaded(sketches),
      );
    }
  }
}
