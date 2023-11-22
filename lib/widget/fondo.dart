import 'package:flutter/material.dart';

class Fondo extends StatelessWidget {
  const Fondo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: Image.asset(
        'assets/images/Fondo_Eventos2.png',
        fit: BoxFit.contain,
      ),
    );
  }
}