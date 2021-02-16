import 'package:flutter/material.dart';
import 'package:hedorapizza/core/models/PizzaOrderBloc.dart';

class PizzaOrderProvider extends InheritedWidget {
  final PizzaOrderBloc bloc;
  final Widget child;
  PizzaOrderProvider({this.bloc, @required this.child}) : super(child: child);

  static PizzaOrderBloc of(BuildContext context) =>
      context.findAncestorWidgetOfExactType<PizzaOrderProvider>().bloc;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;
}
