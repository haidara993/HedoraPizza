import 'package:flutter/cupertino.dart';

class Ingredients {
  final String image;
  final String imageUnit;
  final List<Offset> positions;
  const Ingredients(this.image, this.imageUnit, this.positions);

  bool compare(Ingredients ingredients) => ingredients.image == image;
}

final ingredients = const <Ingredients>[
  Ingredients(
    'assets/images/chili.png',
    'assets/images/chili_unit.png',
    <Offset>[
      Offset(0.35, 0.4),
      Offset(0.2, 0.4),
      Offset(0.4, 0.25),
      Offset(0.5, 0.3),
      Offset(0.4, 0.65),
    ],
  ),
  Ingredients(
    'assets/images/garlic.png',
    'assets/images/garlic.png',
    <Offset>[
      Offset(0.2, 0.35),
      Offset(0.65, 0.35),
      Offset(0.3, 0.23),
      Offset(0.5, 0.2),
      Offset(0.3, 0.5),
    ],
  ),
  Ingredients(
    'assets/images/olive.png',
    'assets/images/olive_unit.png',
    <Offset>[
      Offset(0.4, 0.4),
      Offset(0.5, 0.6),
      Offset(0.25, 0.3),
      Offset(0.4, 0.2),
      Offset(0.25, 0.6),
    ],
  ),
  Ingredients(
    'assets/images/onion.png',
    'assets/images/onion.png',
    <Offset>[
      Offset(0.6, 0.6),
      Offset(0.6, 0.35),
      Offset(0.2, 0.5),
      Offset(0.4, 0.3),
      Offset(0.4, 0.65),
    ],
  ),
  Ingredients(
    'assets/images/pea.png',
    'assets/images/pea_unit.png',
    <Offset>[
      Offset(0.25, 0.35),
      Offset(0.6, 0.45),
      Offset(0.3, 0.25),
      Offset(0.5, 0.25),
      Offset(0.3, 0.55),
    ],
  ),
  Ingredients(
    'assets/images/pickle.png',
    'assets/images/pickle_unit.png',
    <Offset>[
      Offset(0.25, 0.6),
      Offset(0.6, 0.35),
      Offset(0.25, 0.3),
      Offset(0.45, 0.35),
      Offset(0.45, 0.65),
    ],
  ),
  Ingredients(
    'assets/images/potato.png',
    'assets/images/potato_unit.png',
    <Offset>[
      Offset(0.45, 0.45),
      Offset(0.6, 0.45),
      Offset(0.3, 0.23),
      Offset(0.5, 0.25),
      Offset(0.3, 0.5),
    ],
  ),
];
