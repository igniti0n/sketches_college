import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_app/view/options_screen/widgets/settings_menu_button.dart';
import 'package:paint_app/view/painter_screen/widgets/app_painter.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart' as sl;

import '../../contants.dart';
import 'animation_bloc/animation_bloc.dart';

class AnimationPreviewScreen extends StatelessWidget {
  const AnimationPreviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: BlocBuilder<AnimationBloc, AnimationState>(
        builder: (context, state) {
          log(state.toString());
          return Container(
            color: medium,
            child: Row(
              children: [
                ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: _deviceSize.width / 8,
                      maxHeight: _deviceSize.height,
                    ),
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Expanded(child: SpeedSetting()),
                            SettingsMenuButton(
                                onTap: () => Navigator.of(context).pop(),
                                text: 'Back',
                                splashColor: purpleBar),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                        Spacer(),
                      ],
                    )),
                Expanded(
                  child: Center(
                    child: CustomPaint(
                      isComplex: false,
                      willChange: false,
                      foregroundPainter: AppPainter(
                        isPreview: true,
                        drawing: state.drawingToShow,
                      ),
                      child: Container(
                        color: state.drawingToShow.backgroundColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class SpeedSetting extends StatefulWidget {
  SpeedSetting({Key? key}) : super(key: key);

  @override
  _StrokeSettingState createState() => _StrokeSettingState();
}

class _StrokeSettingState extends State<SpeedSetting> {
  double _fps = 4.0;
  @override
  Widget build(BuildContext context) {
    final _animationBloc =
        BlocProvider.of<AnimationBloc>(context, listen: false);
    return sl.SfSlider.vertical(
        value: _fps,
        stepSize: 1.0,
        min: 1.0,
        max: 60.0,
        enableTooltip: true,
        tooltipPosition: sl.SliderTooltipPosition.right,
        interval: 60.0,
        onChanged: (newFps) {
          // log(newStrokeWidth.toString());
          setState(() => _fps = newFps);
          _animationBloc.add(ChangeFps(_fps));
        });
  }
}
