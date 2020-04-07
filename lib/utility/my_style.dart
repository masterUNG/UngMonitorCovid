import 'package:flutter/material.dart';

class MyStyle {
  // Field
  Color primaryColor = Color.fromARGB(0xff, 0x9e, 0x9d, 0x24);
  Color darkColor = Color.fromARGB(0xff, 0x6c, 0x6f, 0x00);

  Widget showCard(String title, String message) {
    return Expanded(
      child: Container(
        constraints: BoxConstraints.expand(),
        child: Card(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(title),
                Text(message),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Method
  MyStyle();
}
