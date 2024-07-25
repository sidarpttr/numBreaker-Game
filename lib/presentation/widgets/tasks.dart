import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:num_breaker/constants/theme/colors.dart';
import 'package:num_breaker/constants/theme/theme.dart';
import 'package:num_breaker/providers/themeProvider.dart';
import 'package:provider/provider.dart';

class TasksWidget extends StatelessWidget {
  const TasksWidget({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme _textTheme = Theme.of(context).textTheme;
    final theme = Provider.of<ThemeProvider>(context).themeData;
    return Container(
      decoration: BoxDecoration(
          gradient: theme == darkTheme ?  DARK_GRADIENT : LIGHT_GRADIENT,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(34))),
      padding: const EdgeInsets.all(30),
      height: 340,
      width: MediaQuery.of(context).size.width,
      child: Text("Today's Mission", style: _textTheme.bodyLarge,).tr(),
    );
  }
}
