import 'package:flutter/material.dart';

class PizzaSizeButtom extends StatelessWidget {
  const PizzaSizeButtom({
    Key key,
    this.selected,
    this.text,
    this.ontap,
  }) : super(key: key);
  final bool selected;
  final String text;
  final VoidCallback ontap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: GestureDetector(
        onTap: ontap,
        child: Container(
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: selected
                  ? [
                      BoxShadow(
                        blurRadius: 5.0,
                        color: Colors.black26,
                        offset: Offset(0.0, 4.0),
                        spreadRadius: 3.0,
                      ),
                    ]
                  : null),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              text,
              style: TextStyle(
                  color: Colors.brown,
                  fontWeight: selected ? FontWeight.bold : FontWeight.w300),
            ),
          ),
        ),
      ),
    );
  }
}
