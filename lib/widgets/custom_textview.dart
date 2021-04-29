import 'package:flutter/material.dart';

class CustomTextView extends StatelessWidget {
  final String text;
  final Color textColor;
  final double fontSize;
  final bool bold;
  final int maxLines;

  CustomTextView({@required this.text, this.textColor = Colors.black, 
  this.fontSize = 14, this.bold = false, this.maxLines});

  @override
  Widget build(BuildContext context) {
    return Text(text,
      maxLines: maxLines,
      overflow: maxLines == null ? TextOverflow.visible : TextOverflow.ellipsis,
      style: TextStyle(
        color: textColor,
        fontSize: fontSize,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}