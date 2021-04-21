import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:paint_app/domain/entities/drawing.dart';
import 'package:paint_app/domain/entities/sketch.dart';
import 'package:paint_app/domain/repositories/drawings_repository.dart';
import 'package:paint_app/view/animation_preview_screen/widgets/animation_preview_controller.dart';

part 'animation_event.dart';
part 'animation_state.dart';

class AnimationBloc extends Bloc<AnimationEvent, AnimationState> {
  AnimationPreviewController _animationPreviewController =
      AnimationPreviewController(Sketch(drawings: [], id: '', sketchName: ''));

  late StreamSubscription _streamSubscription;

  final DrawingsRepository drawingsRepository;
  AnimationBloc(this.drawingsRepository)
      : super(AnimationInitial(Drawing(canvasPaths: []))) {
    _streamSubscription =
        _animationPreviewController.generateFrameCall().listen((drawing) {
      this.add(ChangeFrame(drawing));
    });
  }

  @override
  Stream<AnimationState> mapEventToState(
    AnimationEvent event,
  ) async* {
    if (event is ScreenStarted) {
      _animationPreviewController.setSkecth(drawingsRepository.currentSketch);
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
    }
  }
}
