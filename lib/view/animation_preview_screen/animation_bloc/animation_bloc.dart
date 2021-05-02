import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import '../../../domain/entities/drawing.dart';
import '../../../domain/repositories/drawings_repository.dart';
import '../animation_preview_controller.dart';

part 'animation_event.dart';
part 'animation_state.dart';

class AnimationBloc extends Bloc<AnimationEvent, AnimationState> {
  AnimationPreviewController _animationPreviewController =
      AnimationPreviewController(
    [],
  );

  late StreamSubscription _streamSubscription;

  final DrawingsRepository _drawingsRepository;
  AnimationBloc(this._drawingsRepository)
      : super(AnimationInitial(Drawing(canvasPaths: [], sketchId: '', id: '')));

  @override
  Stream<AnimationState> mapEventToState(
    AnimationEvent event,
  ) async* {
    if (event is ScreenStarted) {
      _animationPreviewController.setSkecth(_drawingsRepository.currentSketch);

      _streamSubscription =
          _animationPreviewController.initialStream().listen((drawing) {
        this.add(ChangeFrame(drawing));
      });
    } else if (event is ChangeFrame) {
      yield DrawingPresented(event.drawing);
    } else if (event is ChangeFps) {
      await _streamSubscription.cancel();
      _animationPreviewController.setFrameDuration(
          Duration(milliseconds: ((1 / event.fps) * 1000).toInt()));
      _streamSubscription =
          _animationPreviewController.generateFrameCall().listen((drawing) {
        this.add(ChangeFrame(drawing));
      });
    } else if (event is ScreenExited) {
      await _streamSubscription.cancel();
      Navigator.of(event.context).pop();
      yield AnimationInitial(Drawing(
        canvasPaths: [],
        id: '',
        sketchId: '',
      ));
    }
  }
}
