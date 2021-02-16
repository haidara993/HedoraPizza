import 'package:flutter/material.dart';
import 'package:hedorapizza/UI/widgets/PizzaIngredientItem.dart';
import 'package:hedorapizza/core/PizzaOrderProvider.dart';
import 'package:hedorapizza/core/models/Ingredients.dart';

class PizzaIngredients extends StatelessWidget {
  const PizzaIngredients({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = PizzaOrderProvider.of(context);

    return ValueListenableBuilder(
        valueListenable: bloc.notifierTotal,
        builder: (context, snapshot, _) {
          final list = bloc.listIngredients;
          return Container(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: ingredients.length,
              itemBuilder: (context, index) {
                final ingredient = ingredients[index];
                return PizzaIngredientItem(
                  ingredients: ingredient,
                  exist: bloc.containsIngredient(ingredient),
                  onTap: () {
                    bloc.removeIngredient(ingredient);
                  },
                );
              },
            ),
          );
        });
  }
}
