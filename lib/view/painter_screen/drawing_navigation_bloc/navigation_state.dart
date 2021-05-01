part of 'navigation_bloc.dart';

abstract class DrawingNavigationState extends Equatable {
  const DrawingNavigationState(this.pageNumber, this.maxPage);
  final int pageNumber;
  final int maxPage;

  @override
  List<Object> get props => [pageNumber];
}

class NavigationInitial extends DrawingNavigationState {
  NavigationInitial(int pageNumber, int maxPage) : super(pageNumber, maxPage);
}

class ChangingDrawing extends DrawingNavigationState {
  ChangingDrawing(int pageNumber, int maxPage) : super(pageNumber, maxPage);
}

class DrawingChanged extends DrawingNavigationState {
  DrawingChanged(int pageNumber, int maxPage) : super(pageNumber, maxPage);
}

class Error extends DrawingNavigationState {
  final String message;

  Error(this.message, int pageNumber, int maxPage) : super(pageNumber, maxPage);
}
