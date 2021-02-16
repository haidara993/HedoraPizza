import 'dart:ui';

import 'package:flutter/foundation.dart' show ChangeNotifier, ValueNotifier;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:hedorapizza/core/enum/PizzaSizeValue.dart';
import 'package:hedorapizza/core/models/Ingredients.dart';
import 'package:hedorapizza/core/models/PizzaMetadata.dart';
import 'package:hedorapizza/core/models/PizzaSizeState.dart';

const initialTotal = 15;

class PizzaOrderBloc extends ChangeNotifier {
  final listIngredients = <Ingredients>[];
  final notifierTotal = ValueNotifier(initialTotal);
  final notifierDeletedIngredient = ValueNotifier<Ingredients>(null);
  final notifierFocused = ValueNotifier(false);
  final notifierPizzaSize =
      ValueNotifier<PizzaSizeState>(PizzaSizeState(PizzaSizeValue.m));
  final notifierBoxAnimation = ValueNotifier(false);
  final notifierCartIconAnimation = ValueNotifier(0);
  final notifierImagePizza = ValueNotifier<PizzaMetadata>(null);
  int totalCart = 0;

  void addIngredient(Ingredients ingredient) {
    listIngredients.add(ingredient);
    // total++;
    notifierTotal.value++;
    // notifyListeners();
  }

  void removeIngredient(Ingredients ingredient) {
    listIngredients.remove(ingredient);
    notifierTotal.value--;
    notifierDeletedIngredient.value = ingredient;
  }

  void refreshDeletedIngredient() {
    notifierDeletedIngredient.value = null;
  }

  bool containsIngredient(Ingredients ingredient) {
    for (Ingredients i in listIngredients) {
      if (i.compare(ingredient)) {
        return true;
      }
    }
    return false;
  }

  void startBoxAnimation() {
    notifierBoxAnimation.value = true;
  }

  void reset() {
    notifierBoxAnimation.value = false;
    notifierImagePizza.value = null;
    notifierTotal.value = initialTotal;
    listIngredients.clear();
    notifierCartIconAnimation.value++;
  }

  Future<void> transformToImage(RenderRepaintBoundary boundary) async {
    final position = boundary.localToGlobal(Offset.zero);
    final size = boundary.size;
    final image = await boundary.toImage();
    ByteData byteData = await image.toByteData(format: ImageByteFormat.png);
    notifierImagePizza.value =
        PizzaMetadata(byteData.buffer.asUint8List(), position, size);
  }
}
