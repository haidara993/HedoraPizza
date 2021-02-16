import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hedorapizza/core/models/PizzaMetadata.dart';

class PizzaOrderAnimation extends StatefulWidget {
  const PizzaOrderAnimation({Key key, this.metadata, this.onComplete})
      : super(key: key);
  final PizzaMetadata metadata;
  final VoidCallback onComplete;

  @override
  _PizzaOrderAnimationState createState() => _PizzaOrderAnimationState();
}

class _PizzaOrderAnimationState extends State<PizzaOrderAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> pizzaScaleAnimation;
  Animation<double> pizzaOpacityAnimation;
  Animation<double> boxEnterScaleAnimation;
  Animation<double> boxExitScaleAnimation;
  Animation<double> boxToCartAnimation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2500));
    pizzaScaleAnimation = Tween(begin: 1.0, end: 0.5).animate(
      CurvedAnimation(
        curve: Interval(0.0, 0.2),
        parent: controller,
      ),
    );
    pizzaOpacityAnimation = CurvedAnimation(
      curve: Interval(0.2, 0.4),
      parent: controller,
    );
    boxEnterScaleAnimation = CurvedAnimation(
      curve: Interval(0.0, 0.2),
      parent: controller,
    );
    boxExitScaleAnimation = Tween(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(
        curve: Interval(0.5, 0.7),
        parent: controller,
      ),
    );
    boxToCartAnimation = CurvedAnimation(
      curve: Interval(0.8, 1.0),
      parent: controller,
    );
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete();
      }
    });
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final metadata = widget.metadata;
    return Positioned(
      top: metadata.position.dy,
      left: metadata.position.dx,
      width: metadata.size.width,
      height: metadata.size.height,
      child: GestureDetector(
        onTap: () {
          widget.onComplete();
        },
        child: AnimatedBuilder(
            animation: controller,
            builder: (context, snapshot) {
              final moveToX = boxToCartAnimation.value > 0
                  ? metadata.position.dx +
                      metadata.size.width / 2 * boxToCartAnimation.value
                  : 0.0;
              final moveToY = boxToCartAnimation.value > 0
                  ? -metadata.size.height / 1.5 * boxToCartAnimation.value
                  : 0.0;
              return Opacity(
                opacity: 1 - boxToCartAnimation.value,
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..translate(moveToX, moveToY)
                    ..rotateZ(boxToCartAnimation.value)
                    ..scale(boxExitScaleAnimation.value),
                  child: Transform.scale(
                    alignment: Alignment.center,
                    scale: 1 - boxToCartAnimation.value,
                    child: Stack(
                      children: [
                        buildBox(),
                        Opacity(
                          opacity: 1 - pizzaOpacityAnimation.value,
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..scale(pizzaScaleAnimation.value)
                              ..translate(
                                0.0,
                                20 * (1 - pizzaOpacityAnimation.value),
                              ),
                            child: Image.memory(widget.metadata.imageBytes),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }

  Widget buildBox() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxHeight = constraints.maxHeight / 2.0;
        final boxWidth = constraints.maxWidth / 2.0;
        final minAngel = -45.0;
        final maxAngel = -125;
        final boxClosingValue =
            lerpDouble(minAngel, maxAngel, 1 - pizzaOpacityAnimation.value);
        return Opacity(
          opacity: boxEnterScaleAnimation.value,
          child: Transform.scale(
            scale: boxEnterScaleAnimation.value,
            child: Stack(
              children: [
                Center(
                  child: Transform(
                    alignment: Alignment.topCenter,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.003)
                      ..rotateX(degreeToRads(minAngel)),
                    child: Image.asset(
                      'assets/images/box_inside.png',
                      height: boxHeight,
                      width: boxWidth,
                    ),
                  ),
                ),
                Center(
                  child: Transform(
                    alignment: Alignment.topCenter,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.003)
                      ..rotateX(degreeToRads(boxClosingValue)),
                    child: Image.asset(
                      'assets/images/box_inside.png',
                      height: boxHeight,
                      width: boxWidth,
                    ),
                  ),
                ),
                if (boxClosingValue >= -90)
                  Center(
                    child: Transform(
                      alignment: Alignment.topCenter,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.003)
                        ..rotateX(degreeToRads(minAngel)),
                      child: Image.asset(
                        'assets/images/box_front.png',
                        height: boxHeight,
                        width: boxWidth,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

num degreeToRads(num deg) {
  return (deg * pi) / 180.0;
}
