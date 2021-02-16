import 'package:hedorapizza/core/enum/PizzaSizeValue.dart';

class PizzaSizeState {
  PizzaSizeState(this.value) : factor = getFactorBySize(value);
  final PizzaSizeValue value;
  final double factor;

  static double getFactorBySize(PizzaSizeValue value) {
    switch (value) {
      case PizzaSizeValue.s:
        return 0.85;
      case PizzaSizeValue.m:
        return 0.95;
      case PizzaSizeValue.l:
        return 1.2;
    }
    return 1.0;
  }
}
