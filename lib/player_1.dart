import 'package:flutter/material.dart';

class MyPlayerOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Image.asset(
        'lib/images/ladrao_1.png',
        // width: MediaQuery.of(context).size.width,
        // fit: BoxFit.cover,
      ),
    );
  }
}
