import 'package:flutter/material.dart';
import 'package:num_breaker/constants/theme/colors.dart';
import 'package:num_breaker/presentation/widgets/numberCard.dart';

class NewGamePage extends StatefulWidget {
  const NewGamePage({super.key});

  @override
  State<NewGamePage> createState() => _NewGamePageState();
}

class _NewGamePageState extends State<NewGamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 56,
          title: Text("NumBreaker"),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: COLOR_SECONDARY,
                  ),
                  GameContent(
                    screenHeight: MediaQuery.of(context).size.height - 56,
                    screenWidth: MediaQuery.of(context).size.width,
                    newGame: true,
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
