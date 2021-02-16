import 'dart:typed_data';

import 'package:flutter/cupertino.dart';

class PizzaMetadata {
  const PizzaMetadata(this.imageBytes, this.position, this.size);
  final Uint8List imageBytes;
  final Offset position;
  final Size size;
}
