import 'package:flutter/material.dart';

class PizzaCartButtom extends StatefulWidget {
  final VoidCallback onTap;
  const PizzaCartButtom({Key key, this.onTap}) : super(key: key);

  @override
  _PizzaCartButtomState createState() => _PizzaCartButtomState();
}

class _PizzaCartButtomState extends State<PizzaCartButtom>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future<void> animateButton() async {
    await animationController.forward(from: 0.0);
    await animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
        animateButton();
      },
      child: AnimatedBuilder(
        animation: animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: (1 -
                    Curves.decelerate.transform(
                      animationController.value,
                    ))
                .clamp(0.5, 1.0),
            child: child,
          );
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.orange.withOpacity(0.5), Colors.orange],
              ),
              boxShadow: [
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4.0,
                    offset: Offset(0.0, 4.0),
                    spreadRadius: 4.0),
              ]),
          child: Icon(
            Icons.shopping_cart_outlined,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }
}
