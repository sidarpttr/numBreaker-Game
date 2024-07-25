import 'package:flutter/material.dart';

const COLOR_PRIMARY = Color(0xFF8186D5);
const COLOR_SECONDARY = Color(0xFFC6CBEF);
const SCAFFOLD_BG = Color(0xFFE3E7F1);
const COLOR_DARKER = Color(0xFF494CA2);
const LIGHT_GRADIENT = LinearGradient(
    colors: [COLOR_SECONDARY, SCAFFOLD_BG],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter);

const DARK_SCAFFOLD_BG = Color(0xFF030303);
const GREY = Color(0xFF1E1E1E);
const DARK_GRADIENT = LinearGradient(
    colors: [GREY, DARK_SCAFFOLD_BG],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter);
