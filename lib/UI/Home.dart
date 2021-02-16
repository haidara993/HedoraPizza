import 'package:flutter/material.dart';
import 'package:hedorapizza/UI/widgets/PizzaCartButtom.dart';
import 'package:hedorapizza/UI/widgets/PizzaCartIcon.dart';
import 'package:hedorapizza/UI/widgets/PizzaDetails.dart';
import 'package:hedorapizza/UI/widgets/PizzaIngredients.dart';
import 'package:hedorapizza/core/PizzaOrderProvider.dart';
import 'package:hedorapizza/core/models/Ingredients.dart';
import 'package:hedorapizza/core/models/PizzaOrderBloc.dart';

const pizzaCartSize = 48.0;

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final bloc = PizzaOrderBloc();
    return PizzaOrderProvider(
      bloc: bloc,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "Hedora Pizza",
            style: TextStyle(
              color: Colors.brown,
              fontSize: 28,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.shopping_cart_rounded),
              color: Colors.brown,
              onPressed: () {},
            ),
          ],
        ),
        body: Stack(
          children: [
            Positioned.fill(
              bottom: 50,
              left: 10,
              right: 10,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                elevation: 10,
                child: Column(
                  children: [
                    Expanded(
                      flex: 12,
                      child: PizzaDetails(),
                    ),
                    Expanded(
                      flex: 5,
                      child: PizzaIngredients(),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 25,
              height: pizzaCartSize,
              width: pizzaCartSize,
              left: MediaQuery.of(context).size.width / 2 - pizzaCartSize / 2,
              child: PizzaCartButtom(
                onTap: () {
                  bloc.startBoxAnimation();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
