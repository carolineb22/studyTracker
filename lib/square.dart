import 'package:flutter/material.dart';

class MySquare extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 100,
        color: Color(0xFF73877B),
      ),
    );
  }
}