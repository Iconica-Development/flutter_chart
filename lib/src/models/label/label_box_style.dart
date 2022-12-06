import 'package:flutter/material.dart';

/// The style of the label box.
class LabelBoxStyle {
  /// The background color of the label box.
  final Color backgroundColor;

  /// The border color of the label box.
  final Color borderColor;

  /// The border radius of the label box.
  final double borderRadius;

  /// The border width of the label box.
  final double borderWidth;

  /// The text style of the label box.
  final TextStyle textStyle;

  const LabelBoxStyle({
    this.backgroundColor = Colors.white,
    this.borderColor = Colors.black,
    this.borderRadius = 5,
    this.borderWidth = 1,
    this.textStyle = const TextStyle(
      color: Colors.black,
      fontSize: 12,
    ),
  });
}
