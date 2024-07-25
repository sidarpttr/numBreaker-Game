import 'package:flutter/material.dart';
import 'package:num_breaker/constants/theme/colors.dart';

Widget PrimaryButton(Text text, Function callback, Size size){
  return GestureDetector(
    onTap: () {
      callback();
    },
    child: Container(
      width: size.width,
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [COLOR_PRIMARY, COLOR_DARKER]),
        borderRadius: BorderRadius.all(Radius.circular(100)),
      ),
      alignment: Alignment.center,
      child: text,
    ),
  );
}