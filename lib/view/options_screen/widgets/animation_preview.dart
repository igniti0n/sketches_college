import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_app/view/painter_screen/drawing_bloc/drawing_bloc.dart';
import 'package:paint_app/view/painter_screen/settings_bloc/settings_bloc.dart';
import 'package:paint_app/view/painter_screen/widgets/app_painter.dart';

//!¨curretnly not used jbg
class AnimationPreview extends StatelessWidget {
  const AnimationPreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final _size = MediaQuery.of(context).size;
    final _drawingBloc = BlocProvider.of<DrawingBloc>(context);

    return BlocBuilder<DrawingBloc, DrawingState>(
      builder: (context, state) {
        return Center(
          child: CustomPaint(
            isComplex: false,
            willChange: false,
            foregroundPainter: AppPainter(
              isPreview: true,
              drawing: state.currentDrawing,
            ),
            child: Container(
              color: state.currentDrawing.backgroundColor,
            ),
          ),
        );
      },
    );
  }
}
