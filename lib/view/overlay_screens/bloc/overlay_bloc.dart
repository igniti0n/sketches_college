import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:paint_app/domain/entities/sketch.dart';
import 'package:paint_app/domain/repositories/sketches_repository.dart';
import 'package:paint_app/view/overlay_screens/overlay_edit_sketch.dart';

part 'overlay_event.dart';
part 'overlay_state.dart';

class OverlayBloc extends Bloc<OverlayEvent, OverlayState> {
  final SketchesRepository _sketchesRepository;
  OverlayBloc(this._sketchesRepository) : super(OverlayInitial());

  @override
  Stream<OverlayState> mapEventToState(
    OverlayEvent event,
  ) async* {
    if (event is ShowEditOverlay) {
      showEditSketchOverlay(event.context, event.sketch);
      yield OverlayEditSketchStarted();
    } else if (event is ExitOverlay) {
      Navigator.of(event.context).pop();
      yield OverlayInitial();
    } else if (event is EditSketch) {
      yield OverlayLoading();
      final either = await _sketchesRepository.editSketch(event.editedSketch);
      yield either.fold((l) => OverlayError(""), (r) => OverlaySuccess());
    }
  }
}
