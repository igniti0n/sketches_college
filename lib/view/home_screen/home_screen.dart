import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../overlay_screens/overlay_bloc/overlay_bloc.dart';

import '../../contants.dart';
import 'sketches_bloc/sketches_bloc.dart';
import 'widgets/sketch_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context);
    final _deviceSize = _mediaQuery.size;
    final _sketchesBloc = BlocProvider.of<SketchesBloc>(context);
    _sketchesBloc.add(FetchAllSketches());

    return Scaffold(
      backgroundColor: dark,
      body: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(40)),
          color: medium,
        ),
        child: BlocConsumer<SketchesBloc, SketchesState>(
          builder: (ctx, state) {
            // log(state.toString());
            if (state.sketches.isEmpty && state is SketchesLoaded) {
              return Center(
                child: Text(
                  'Add some sketches to get started!',
                  style: Theme.of(ctx).textTheme.bodyText1,
                ),
              );
            } else {
              return GridView.builder(
                  itemCount: state.sketches.length,
                  //  +
                  // ((state is LoadingSketches) ? 1 : 0),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: _deviceSize.width /
                          ((_mediaQuery.orientation == Orientation.landscape)
                              ? 3
                              : 2)),
                  itemBuilder: (ctx, index) {
                    // if ((state is LoadingSketches) &&
                    //     index == state.sketches.length) return _buildLoading();
                    return SketchWidget(sketch: state.sketches[index]);
                  });
            }
          },
          listener: (ctx, state) {
            if (state is Error)
              BlocProvider.of<OverlayBloc>(context).add(ShowErrorOverlay(
                context: ctx,
                message: state.message,
              ));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        //TODO: DA DODAJE U BAZU I DA SE OTVORI IME ZA DAVANJE SKETCHU I ODLAZAK NA SKETCH
        onPressed: () => _sketchesBloc.add(AddNewSketch()),
        isExtended: true,
        backgroundColor: Colors.purple[400],
        child: Icon(
          Icons.add,
          size: 40,
        ),
      ),
    );
  }
}

class CircleClipper extends CustomClipper<Path> {
  final Path _path = Path();

  @override
  getClip(Size size) {
    _path.addOval(Rect.fromCenter(
        center: Offset(size.width / 2, size.height / 2),
        width: size.width * 0.95,
        height: size.height * 0.95));

    return _path;
  }

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) => false;
}
