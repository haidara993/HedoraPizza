import 'package:flutter/material.dart';
import 'package:hedorapizza/core/PizzaOrderProvider.dart';

class PizzaCartIcon extends StatefulWidget {
  PizzaCartIcon({Key key}) : super(key: key);

  @override
  _PizzaCartIconState createState() => _PizzaCartIconState();
}

class _PizzaCartIconState extends State<PizzaCartIcon>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animationScaleOut;
  Animation<double> animationScaleIn;
  int counter = 0;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    animationScaleOut =
        CurvedAnimation(curve: Interval(0.0, 0.5), parent: controller);
    animationScaleIn =
        CurvedAnimation(curve: Interval(5.0, 0.0), parent: controller);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bloc = PizzaOrderProvider.of(context);
      bloc.notifierCartIconAnimation.addListener(() {
        counter = bloc.notifierCartIconAnimation.value;
        controller.forward(from: 0.0);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: controller,
        builder: (context, snapshot) {
          double scale;
          const scaleFactor = 0.5;
          if (animationScaleOut.value < 0.1) {
            scale = 1.0 + scaleFactor * animationScaleOut.value;
          } else if (animationScaleIn.value <= 0.1) {
            scale = (1.0 + scaleFactor) - scaleFactor * animationScaleIn.value;
          }
          return Transform.scale(
            alignment: Alignment.center,
            scale: scale,
            child: Stack(
              children: [
                IconButton(
                  icon: Icon(Icons.shopping_cart_rounded),
                  color: Colors.brown,
                  onPressed: () {},
                ),
                if (animationScaleOut.value > 0)
                  Positioned(
                    top: 7,
                    right: 7,
                    child: Transform.scale(
                      alignment: Alignment.center,
                      scale: animationScaleOut.value,
                      child: CircleAvatar(
                        radius: 7,
                        backgroundColor: Colors.red,
                        child: Text(
                          counter.toString(),
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  )
              ],
            ),
          );
        });
  }
}
