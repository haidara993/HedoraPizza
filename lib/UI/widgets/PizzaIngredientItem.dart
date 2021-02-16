import 'package:flutter/material.dart';
import 'package:hedorapizza/core/models/Ingredients.dart';

class PizzaIngredientItem extends StatelessWidget {
  final Ingredients ingredients;
  final bool exist;
  final VoidCallback onTap;
  const PizzaIngredientItem({Key key, this.ingredients, this.exist, this.onTap})
      : super(key: key);

  Widget buildChild({bool withImage = true}) {
    return GestureDetector(
      onTap: exist ? onTap : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7.0),
        child: Container(
          height: 45,
          width: 45,
          decoration: BoxDecoration(
              color: Colors.pink.withOpacity(0.1),
              shape: BoxShape.circle,
              border: exist ? Border.all(color: Colors.red, width: 2) : null),
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: withImage
                ? Image.asset(
                    ingredients.image,
                    fit: BoxFit.contain,
                  )
                : SizedBox.fromSize(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: exist
          ? buildChild()
          : Draggable(
              feedback: DecoratedBox(
                decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                  BoxShadow(
                      blurRadius: 10.0,
                      color: Colors.black26,
                      offset: Offset(0.0, 5.0),
                      spreadRadius: 5.0)
                ]),
                child: buildChild(),
              ),
              childWhenDragging: buildChild(withImage: false),
              data: ingredients,
              child: buildChild(),
            ),
    );
  }
}
