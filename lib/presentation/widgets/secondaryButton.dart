import 'package:flutter/material.dart';
import 'package:num_breaker/constants/theme/colors.dart';

Widget SecondaryButton(Text text, Function callback, Size size) {
  return GestureDetector(
    onTap: (){ callback();},
    child: Container(
      width: size.width,
      padding: const EdgeInsets.symmetric(vertical: 13),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: COLOR_SECONDARY,
          borderRadius: const BorderRadius.all(Radius.circular(100)),
          border: Border.all(color: COLOR_PRIMARY)),
      child: text,
    ),
  );
}
