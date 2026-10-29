import 'package:flutter/material.dart';

class ItemDetails extends StatelessWidget {
  final String title;
  final String value;
  final double fontSize;
  final FontWeight fontWeight;
  Color? color;
   ItemDetails({
    super.key,
    required this.title,
    required this.value,
    this.fontSize = 14,
    this.fontWeight = FontWeight.normal,this.color
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: fontSize, fontWeight: fontWeight,color: color),
        ),
        Text(
          '₹ $value',
          style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
        ),
      ],
    );
  }
}
