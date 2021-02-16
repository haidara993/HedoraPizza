import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hedorapizza/UI/widgets/PizaaSizeButtom.dart';
import 'package:hedorapizza/UI/widgets/PizzaOrderAnimation.dart';
import 'package:hedorapizza/core/PizzaOrderProvider.dart';
import 'package:hedorapizza/core/enum/PizzaSizeValue.dart';
import 'package:hedorapizza/core/models/Ingredients.dart';
import 'package:hedorapizza/core/models/PizzaMetadata.dart';
import 'package:hedorapizza/core/models/PizzaSizeState.dart';

class PizzaDetails extends StatefulWidget {
  const PizzaDetails({Key key}) : super(key: key);

  @override
  _PizzaDetailsState createState() => _PizzaDetailsState();
}

class _PizzaDetailsState extends State<PizzaDetails>
    with TickerProviderStateMixin {
  AnimationController animationController;
  AnimationController animationRotationController;

  List<Animation> animationList = <Animation>[];
  BoxConstraints pizzaConstrains;
  final keyPizza = GlobalKey();

  Widget buildIngredientsWidget(Ingredients deletedIngredient) {
    List<Widget> elements = [];
    final listIngredients =
        List.from(PizzaOrderProvider.of(context).listIngredients);
    if (deletedIngredient != null) {
      listIngredients.add(deletedIngredient);
    }
    if (animationList.isNotEmpty) {
      for (var i = 0; i < listIngredients.length; i++) {
        Ingredients ingredient = listIngredients[i];
        final ingredientsWidget = Image.asset(
          ingredient.imageUnit,
          height: 40,
        );
        for (var j = 0; j < ingredient.positions.length; j++) {
          final animation = animationList[j];
          final position = ingredient.positions[j];
          final positionX = position.dx;
          final positionY = position.dy;

          if (i == listIngredients.length - 1 &&
              animationController.isAnimating) {
            double fromX = 0.0, fromY = 0.0;
            if (j < 1) {
              fromX = pizzaConstrains.maxWidth * (1 - animation.value);
            } else if (j < 2) {
              fromX = pizzaConstrains.maxWidth * (1 - animation.value);
            } else if (j < 3) {
              fromY = pizzaConstrains.maxHeight * (1 - animation.value);
            } else {
              fromY = pizzaConstrains.maxHeight * (1 - animation.value);
            }

            final opacity = animation.value;
            if (animation.value > 0) {
              elements.add(
                Opacity(
                  opacity: opacity,
                  child: Transform(
                    transform: Matrix4.identity()
                      ..translate(
                        fromX + pizzaConstrains.maxWidth * positionX,
                        fromY + pizzaConstrains.maxHeight * positionY,
                      ),
                    child: ingredientsWidget,
                  ),
                ),
              );
            }
          } else {
            elements.add(
              Transform(
                transform: Matrix4.identity()
                  ..translate(
                    pizzaConstrains.maxWidth * positionX,
                    pizzaConstrains.maxHeight * positionY,
                  ),
                child: ingredientsWidget,
              ),
            );
          }
        }
      }
      return Stack(
        children: elements,
      );
    }
    return SizedBox.fromSize();
  }

  Future<void> animateDeletedIngredient(Ingredients ingredient) async {
    if (ingredient != null) {
      await animationController.reverse(from: 1.0);
      final bloc = PizzaOrderProvider.of(context);
      bloc.refreshDeletedIngredient();
    }
  }

  void buildIngredientsAninamtion() {
    animationList.clear();
    animationList.add(CurvedAnimation(
      curve: Interval(0.0, 0.8, curve: Curves.decelerate),
      parent: animationController,
    ));
    animationList.add(CurvedAnimation(
      curve: Interval(0.2, 0.8, curve: Curves.decelerate),
      parent: animationController,
    ));
    animationList.add(CurvedAnimation(
      curve: Interval(0.4, 1.0, curve: Curves.decelerate),
      parent: animationController,
    ));
    animationList.add(CurvedAnimation(
      curve: Interval(0.1, 0.7, curve: Curves.decelerate),
      parent: animationController,
    ));
    animationList.add(CurvedAnimation(
      curve: Interval(0.3, 1.0, curve: Curves.decelerate),
      parent: animationController,
    ));
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    animationRotationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = PizzaOrderProvider.of(context);
      bloc.notifierBoxAnimation.addListener(() {
        if (bloc.notifierBoxAnimation.value) {
          addPizzaToCart();
        }
      });
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    animationRotationController.dispose();
    super.dispose();
  }

  void addPizzaToCart() {
    final bloc = PizzaOrderProvider.of(context);
    RenderRepaintBoundary boundary = keyPizza.currentContext.findRenderObject();
    bloc.transformToImage(boundary);
  }

  OverlayEntry overlayEntry;
  void startPizzaBoxAnimation(PizzaMetadata metadata) {
    final bloc = PizzaOrderProvider.of(context);
    if (overlayEntry == null) {
      overlayEntry = OverlayEntry(
        builder: (context) {
          return PizzaOrderAnimation(
            metadata: metadata,
            onComplete: () {
              overlayEntry.remove();
              overlayEntry = null;
              bloc.reset();
            },
          );
        },
      );
      Overlay.of(context).insert(overlayEntry);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = PizzaOrderProvider.of(context);
    return Column(
      children: [
        Expanded(
          child: DragTarget<Ingredients>(
            onAccept: (ingredient) {
              print('onAccept');
              bloc.notifierFocused.value = false;
              bloc.addIngredient(ingredient);
              // setState(() {
              //   bloc.total++;
              // });
              buildIngredientsAninamtion();
              animationController.forward(from: 0.0);
            },
            onWillAccept: (ingredient) {
              print("onWillAccept");
              bloc.notifierFocused.value = true;
              return !bloc.containsIngredient(ingredient);
            },
            onLeave: (ingredient) {
              print("onLeave");
              bloc.notifierFocused.value = false;
            },
            builder: (context, candidateData, rejectedData) {
              return LayoutBuilder(
                builder: (context, constraints) {
                  pizzaConstrains = constraints;
                  return ValueListenableBuilder<PizzaMetadata>(
                      valueListenable: bloc.notifierImagePizza,
                      builder: (context, data, child) {
                        if (data != null) {
                          Future.microtask(() => startPizzaBoxAnimation(data));
                        }
                        return AnimatedOpacity(
                          duration: const Duration(milliseconds: 60),
                          opacity: data != null ? 0.0 : 1,
                          child: ValueListenableBuilder<PizzaSizeState>(
                            valueListenable: bloc.notifierPizzaSize,
                            builder: (context, value, _) {
                              return RepaintBoundary(
                                key: keyPizza,
                                child: RotationTransition(
                                  turns: CurvedAnimation(
                                      curve: Curves.elasticOut,
                                      parent: animationRotationController),
                                  child: Stack(
                                    children: [
                                      Center(
                                        child: ValueListenableBuilder<bool>(
                                            valueListenable:
                                                bloc.notifierFocused,
                                            builder: (context, focused, _) {
                                              return AnimatedContainer(
                                                duration: const Duration(
                                                    milliseconds: 400),
                                                width: focused
                                                    ? constraints.maxWidth *
                                                        value.factor
                                                    : constraints.maxWidth *
                                                            value.factor -
                                                        20,
                                                height: focused
                                                    ? constraints.maxHeight *
                                                        value.factor
                                                    : constraints.maxHeight *
                                                            value.factor -
                                                        20,
                                                // width: focused
                                                //     ? constraints.maxHeight
                                                //     : constraints.maxHeight - 20,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      15.0),
                                                  child: Stack(
                                                    children: [
                                                      DecoratedBox(
                                                          decoration:
                                                              BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  boxShadow: [
                                                                BoxShadow(
                                                                    blurRadius:
                                                                        10.0,
                                                                    color: Colors
                                                                        .black26,
                                                                    offset:
                                                                        Offset(
                                                                            0.0,
                                                                            5.0),
                                                                    spreadRadius:
                                                                        5.0)
                                                              ]),
                                                          child: Image.asset(
                                                              'assets/images/dish.png')),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(15.0),
                                                        child: Image.asset(
                                                            'assets/images/pizza-1.png'),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }),
                                      ),
                                      ValueListenableBuilder<Ingredients>(
                                          valueListenable:
                                              bloc.notifierDeletedIngredient,
                                          builder: (context, snapshot, _) {
                                            animateDeletedIngredient(snapshot);

                                            return AnimatedBuilder(
                                              animation: animationController,
                                              builder: (context, child) {
                                                return buildIngredientsWidget(
                                                    snapshot);
                                              },
                                            );
                                          }),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      });
                },
              );
            },
          ),
        ),
        SizedBox(
          height: 5,
        ),
        ValueListenableBuilder<int>(
            valueListenable: bloc.notifierTotal,
            builder: (context, snapshot, child) {
              return AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: animation.drive(Tween<Offset>(
                          begin: Offset(0.0, 0.0),
                          end: Offset(0.0, animation.value))),
                      child: child,
                    ),
                  );
                },
                child: Text(
                  '\$$snapshot',
                  key: UniqueKey(),
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown),
                ),
              );
            }),
        SizedBox(
          height: 15,
        ),
        ValueListenableBuilder<PizzaSizeState>(
            valueListenable: bloc.notifierPizzaSize,
            builder: (context, value, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PizzaSizeButtom(
                    text: "S",
                    ontap: () {
                      bloc.notifierPizzaSize.value =
                          PizzaSizeState(PizzaSizeValue.s);
                      animationRotationController.forward(from: 0.0);
                    },
                    selected: value.value == PizzaSizeValue.s,
                  ),
                  PizzaSizeButtom(
                    text: "M",
                    ontap: () {
                      bloc.notifierPizzaSize.value =
                          PizzaSizeState(PizzaSizeValue.m);
                      animationRotationController.forward(from: 0.0);
                    },
                    selected: value.value == PizzaSizeValue.m,
                  ),
                  PizzaSizeButtom(
                    text: "L",
                    ontap: () {
                      bloc.notifierPizzaSize.value =
                          PizzaSizeState(PizzaSizeValue.l);
                      animationRotationController.forward(from: 0.0);
                    },
                    selected: value.value == PizzaSizeValue.l,
                  ),
                ],
              );
            })
      ],
    );
  }
}
