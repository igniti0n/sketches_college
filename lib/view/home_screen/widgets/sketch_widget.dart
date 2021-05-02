import 'dart:math';

import 'package:auto_size_text_pk/auto_size_text_pk.dart';
import 'package:flutter/material.dart' hide OverlayState;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../overlay_screens/overlay_bloc/overlay_bloc.dart';

import '../../../contants.dart';
import '../../../core/navigation/router.dart';
import '../../../domain/entities/sketch.dart';
import '../../painter_screen/drawing_bloc/drawing_bloc.dart';
import '../home_screen.dart';
import 'sketch_button.dart';

class SketchWidget extends StatefulWidget {
  final Sketch sketch;
  final double beginAnimate;
  final double endAnimate;
  // final AnimationController animationController;
  SketchWidget({
    Key? key,
    required this.sketch,
    // required this.animationController,
    required this.beginAnimate,
    required this.endAnimate,
  }) : super(key: key);

  @override
  _SketchWidgetState createState() => _SketchWidgetState();
}

class _SketchWidgetState extends State<SketchWidget>
    with SingleTickerProviderStateMixin {
  final Random rand = Random();

  late final AnimationController _animationController;
  late final Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        widget.beginAnimate,
        widget.endAnimate,
        curve: Curves.easeOutCubic,
      ),
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _animationController.forward();
    final _overlayBloc = BlocProvider.of<OverlayBloc>(context);

    return BlocListener<OverlayBloc, OverlayState>(
      listener: (_, state) {
        if (state is OverlaySuccess) {
          if (state.sketchId == widget.sketch.id)
            _animationController.reverse();
        }
      },
      child: GestureDetector(
        onTap: () {
          BlocProvider.of<DrawingBloc>(context)
              .add(ScreenOpened(widget.sketch.id));
          Navigator.pushReplacementNamed(context, PAINT_SCREEN_ROUTE);
        },
        child: ScaleTransition(
          scale: _opacityAnimation,
          child: Container(
            alignment: Alignment.center,
            child: ClipPath(
              clipper: CircleClipper(),
              child: Container(
                color: Colors.grey.withAlpha(150),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Align(
                      alignment: Alignment.bottomCenter,
                      child: LayoutBuilder(builder: (ctx, cons) {
                        // dev.log(cons.toString());
                        return SizedBox(
                          width: cons.maxWidth / 1.5,
                          height: cons.maxHeight / 2,
                          child: AutoSizeText(
                            widget.sketch.sketchName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 140,
                            ),
                            maxFontSize: 40,
                          ),
                        );
                      }),
                    )),
                    Expanded(
                      child: LayoutBuilder(
                        builder: (ctx, cons) => Row(
                          children: [
                            Expanded(
                              child: SketchButton(
                                icon: Icons.remove_circle,
                                splashColor: Colors.red[900]!,
                                iconColor: Colors.black,
                                onTap: () => _overlayBloc.add(
                                    ShowDeleteSketchOverlay(
                                        sketch: widget.sketch,
                                        context: context)),
                                maxWidth: cons.maxWidth,
                              ),
                            ),
                            Expanded(
                              child: SketchButton(
                                icon: Icons.edit,
                                splashColor: Colors.purple,
                                onTap: () => _overlayBloc.add(ShowEditOverlay(
                                    sketch: widget.sketch, context: context)),
                                maxWidth: cons.maxWidth,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            decoration: BoxDecoration(
              border: Border.all(color: dark, width: 4),
              //borderRadius: BorderRadius.all(Radius.circular(140)),
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            padding: EdgeInsets.all(4),
            margin: EdgeInsets.all(4),
          ),
        ),
      ),
    );
  }
}
