import 'package:flutter/material.dart';

class InputWidget extends StatelessWidget {
  static const double _widthScale = 0.8;
  final String labelText;
  final Color color;
  final Color cursorColor;
  final Icon icon;
  final TextEditingController? controller;
  final bool isPassword;

  InputWidget(
    this.controller, {
    this.isPassword = false,
    super.key,
    this.labelText = "Text",
    this.color = Colors.black,
    this.cursorColor = Colors.cyan,
    this.icon = const Icon(
      Icons.abc,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * _widthScale,
      child: TextField(
        obscureText: isPassword,
        enableSuggestions: !isPassword,
        autocorrect: !isPassword,
        controller: controller,
        cursorColor: cursorColor,
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
