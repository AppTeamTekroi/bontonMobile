import 'package:flutter/material.dart';

class BontonLogo extends StatelessWidget {
  final double height;

  const BontonLogo({super.key, this.height = 48});

  static const asset = 'lib/ui/assets/bonton_logo.png';

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      height: height,
      fit: BoxFit.contain,
    );
  }
}
