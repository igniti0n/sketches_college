import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'sketches_event.dart';
part 'sketches_state.dart';

class SketchesBloc extends Bloc<SketchesEvent, SketchesState> {
  SketchesBloc() : super(SketchesInitial());

  @override
  Stream<SketchesState> mapEventToState(
    SketchesEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
