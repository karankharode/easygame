import 'package:easygame/constants/colors.dart';
import 'package:flutter/material.dart';

InputDecoration getInputDecoration(
    String labelText, Color _fillColor, Color _labelColor, prefixIcon, suffixIcon) {
  const double borderWidth = 2;
  const double borderRadius = 12;
  const double gapPadding = 8;
  return InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: textFieldFillColor,
          width: borderWidth,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        gapPadding: gapPadding,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: colorPrimary,
          width: borderWidth,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        gapPadding: gapPadding,
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(
          color: colorPrimary,
          width: borderWidth,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        gapPadding: gapPadding,
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: gapPadding * 2,
        vertical: gapPadding * 2,
      ),
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon,
      labelText: labelText,
      focusColor: bgColor,
      fillColor: _fillColor,
      hoverColor: bgColor,
      filled: true,
      hintStyle: TextStyle(
        fontSize: 14,
        color: secondaryAccent,
        fontFamily: 'GothamMedium',
      ),
      labelStyle: TextStyle(
        fontSize: 14,
        color: _labelColor,
        fontFamily: 'GothamMedium',
      ));
}
