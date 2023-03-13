import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  static const double _widthScale = 0.8;
  final String labelText;
  final Color color;
  final Icon icon;

  const Input({
    super.key,
    this.labelText = "Text",
    this.color = Colors.black,
    this.icon = const Icon(
      Icons.abc,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * _widthScale,
      child: TextField(
        cursorColor: color,
        decoration: InputDecoration(
          label: Text(labelText),
          labelStyle: TextStyle(color: color),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: color,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: color,
            ),
          ),
          prefixIcon: icon,
        ),
      ),
    );
  }
}