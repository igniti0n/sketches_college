import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_app/view/overlay_screens/state_views.dart';
import '../../contants.dart';
import '../../core/error/settings_menu_button.dart';
import '../../domain/entities/sketch.dart';
import '../home_screen/sketches_bloc/sketches_bloc.dart';
import 'package:paint_app/view/overlay_screens/overlay_bloc/overlay_bloc.dart'
    as ob;

Future<void> showEditSketchOverlay(
  BuildContext context,
  Sketch editingSketch,
) {
  return showDialog<void>(
    context: context,
    builder: (_) => EditSketchDialog(
      editingSketch: editingSketch,
    ),
  );
}

class EditSketchDialog extends StatefulWidget {
  final Sketch editingSketch;
  const EditSketchDialog({Key? key, required this.editingSketch})
      : super(key: key);

  @override
  _EditSketchDialogState createState() => _EditSketchDialogState();
}

class _EditSketchDialogState extends State<EditSketchDialog> {
  final TextEditingController _controller = TextEditingController();
  // late Sketch _editingSketch;

  String _sketchName = '';

  @override
  void initState() {
    super.initState();
    // _editingSketch = widget.editingSketch;
    _sketchName = widget.editingSketch.sketchName;
    _controller.text = _sketchName;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ob.OverlayBloc, ob.OverlayState>(
      builder: (context, state) {
        if (state is ob.OverlayLoading) {
          return loadingView(context);
        } else if (state is ob.OverlayError) {
          return outcomeView(context, state.message, () {
            BlocProvider.of<ob.OverlayBloc>(context)
                .add(ob.ExitOverlay(context));
            BlocProvider.of<SketchesBloc>(context).add(FetchAllSketches());
          });
        } else if (state is ob.OverlaySuccess) {
          return outcomeView(context, state.message, () {
            BlocProvider.of<SketchesBloc>(context).add(FetchAllSketches());
            BlocProvider.of<ob.OverlayBloc>(context)
                .add(ob.ExitOverlay(context));
          });
        } else if (state is ob.OverlayEditSketchStarted) {
          return _editView(context);
        } else if (state is ob.OverlayDeleteSketchStarted) {
          return _deleteView(context);
        }
        return Container();
      },
    );
  }

  SimpleDialog _editView(BuildContext context) {
    return SimpleDialog(
      backgroundColor: overlayBackground,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _controller,
            textInputAction: TextInputAction.done,
            onChanged: (String text) => _sketchName = text,
          ),
        ),
        SettingsMenuButton(
          onTap: () =>
              BlocProvider.of<ob.OverlayBloc>(context).add(ob.EditSketch(
            _sketchName,
            widget.editingSketch.id,
          )),
          splashColor: purpleBar,
          text: 'Done',
        ),
      ],
    );
  }

  SimpleDialog _deleteView(
    BuildContext context,
  ) {
    return SimpleDialog(
      backgroundColor: overlayBackground,
      title: Text("You want to proceed?"),
      children: [
        Center(
          child: SizedBox(
            width: 300,
            child: SingleChildScrollView(
              child: Text(
                  'YOu want to delete sketch: \n ${widget.editingSketch.sketchName}?'),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SettingsMenuButton(
              onTap: () => BlocProvider.of<ob.OverlayBloc>(context).add(
                ob.DeleteSketch(
                  widget.editingSketch.id,
                ),
              ),
              splashColor: purpleBar,
              contentColor: Colors.red.withAlpha(170),
              text: 'delete',
            ),
            SettingsMenuButton(
              onTap: () => BlocProvider.of<ob.OverlayBloc>(context)
                  .add(ob.ExitOverlay(context)),
              splashColor: purpleBar,
              text: 'Keep',
            ),
          ],
        ),
      ],
    );
  }
}
