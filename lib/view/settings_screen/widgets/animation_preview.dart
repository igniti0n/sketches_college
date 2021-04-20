import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_app/view/painter_screen/drawing_bloc/drawing_bloc.dart';
import 'package:paint_app/view/settings_screen/settings_bloc/settings_bloc.dart';

class AnimationPreview extends StatelessWidget {
  const AnimationPreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final _size = MediaQuery.of(context).size;
    final _drawingBloc = BlocProvider.of<DrawingBloc>(context);

    return BlocBuilder<DrawingBloc, DrawingState>(
      builder: (context, state) {
        return CustomPaint(
          isComplex: true,
          willChange: true,
          // foregroundPainter: AppPainter(
          //   drawing: state.currentDrawing,
          // ),
          // painter: AppPainter(
          //   drawing: state.previousDrawing,
          //   isForeground: false,
          // ),
          child: BlocListener<SettingsBloc, SettingsState>(
            listener: (context, state) {
              // _currentPaintSettings = state.paintSettings;
            },
            child: Container(
              constraints: BoxConstraints(),
              color: Colors.transparent,
            ),
          ),
        );
      },
    );
  }
}
