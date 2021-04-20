import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paint_app/domain/entities/sketch.dart';
import 'package:paint_app/view/home_screen/sketches_bloc/sketches_bloc.dart';
import 'package:paint_app/view/overlay_screens/bloc/overlay_bloc.dart' as ob;

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
          return _loadingView(context);
        } else if (state is ob.OverlayError) {
          return _errorView(context, state.message);
        } else if (state is ob.OverlaySuccess) {
          return _successView(context, state.message);
        } else if (state is ob.OverlayEditSketchStarted) {
          return _editView(context);
        } else if (state is ob.OverlayDeleteSketchStarted) {
          return _deleteView(context);
        }
        return Container();
      },
    );
  }

  SimpleDialog _loadingView(BuildContext context) {
    return SimpleDialog(
      title: Text("Processing..."),
      children: [
        CircularProgressIndicator(),
      ],
    );
  }

  SimpleDialog _errorView(BuildContext context, String errorMessage) {
    return SimpleDialog(
      title: Text(errorMessage),
      children: [
        TextButton(
            onPressed: () {
              BlocProvider.of<ob.OverlayBloc>(context)
                  .add(ob.ExitOverlay(context));
              BlocProvider.of<SketchesBloc>(context).add(FetchAllSketches());
            },
            child: Text("Done")),
      ],
    );
  }

  SimpleDialog _successView(BuildContext context, String message) {
    return SimpleDialog(
      title: Text(message),
      children: [
        TextButton(
            onPressed: () {
              BlocProvider.of<SketchesBloc>(context).add(FetchAllSketches());
              BlocProvider.of<ob.OverlayBloc>(context)
                  .add(ob.ExitOverlay(context));
            },
            child: Text("Done")),
      ],
    );
  }

  SimpleDialog _editView(BuildContext context) {
    return SimpleDialog(
      children: [
        TextField(
          controller: _controller,
          textInputAction: TextInputAction.done,
          onChanged: (String text) => _sketchName = text,
        ),
        TextButton(
            onPressed: () {
              BlocProvider.of<ob.OverlayBloc>(context).add(ob.EditSketch(
                Sketch(
                  drawings: widget.editingSketch.drawings,
                  id: widget.editingSketch.id,
                  sketchName: _sketchName,
                ),
              ));
            },
            child: Text("Done")),
      ],
    );
  }

  SimpleDialog _deleteView(
    BuildContext context,
  ) {
    return SimpleDialog(
      title:
          Text("You want to delete sketch ${widget.editingSketch.sketchName}?"),
      children: [
        TextButton(
            onPressed: () {
              BlocProvider.of<ob.OverlayBloc>(context).add(ob.DeleteSketch(
                widget.editingSketch.id,
              ));
            },
            child: Text("Delete")),
        TextButton(
            onPressed: () {
              BlocProvider.of<ob.OverlayBloc>(context)
                  .add(ob.ExitOverlay(context));
            },
            child: Text("Keep")),
      ],
    );
  }
}
