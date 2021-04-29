import 'package:flutter/material.dart';

typedef OnTextChanged = void Function(String);

class CustomInputField extends StatefulWidget {
  final Color textColor;
  final Color hintTextColor;
  final TextEditingController controller;
  final bool obscureText;
  final String hint;
  final TextInputType inputType;
  final Icon prefix;
  final OnTextChanged onTextChanged;
  final int maxLines;
  final showUnderline;

  CustomInputField({@required this.controller, this.textColor = Colors.black, this.hintTextColor, 
    this.obscureText = false, @required this.hint, this.inputType = TextInputType.text, this.prefix, this.onTextChanged, 
    this.maxLines, this.showUnderline = false});

  @override
  _CustomInputFieldState createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      maxLines: widget.maxLines,
      style: TextStyle(
        color: widget.textColor
      ),
      decoration: InputDecoration(
        hintText: widget.hint,
        border: widget.showUnderline ? null : InputBorder.none,
        hintStyle: TextStyle(
          color: widget.hintTextColor ?? Colors.grey.shade500
        ),
        prefixIcon: widget.prefix
      ),
      keyboardType: widget.inputType,
      obscureText: widget.obscureText,
      onChanged: widget.onTextChanged,
    );
  }
}