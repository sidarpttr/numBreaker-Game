import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:num_breaker/presentation/pages/newGame.dart';
import 'package:num_breaker/presentation/pages/savedGame.dart';
import 'package:num_breaker/presentation/widgets/primaryButton.dart';
import 'package:num_breaker/presentation/widgets/secondaryButton.dart';
import 'package:num_breaker/presentation/widgets/tasks.dart';
import 'package:num_breaker/providers/gameProvider.dart';
import 'package:num_breaker/utils/hellper.dart';
import 'package:provider/provider.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  String? lastGame;
  @override
  Widget build(BuildContext context) {
    print(Provider.of<GameProvider>(context).game);
    TextTheme _textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Expanded(child: TasksWidget()),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "How To Play?",
                    style: _textTheme.bodyLarge,
                  ).tr(),
                  addVerticalSpace(20),
                  SecondaryButton(
                      Text(
                        Provider.of<GameProvider>(context).game != null
                            ? "Resume Game"
                            : "-",
                        style: _textTheme.bodyLarge,
                      ).tr(),
                      Provider.of<GameProvider>(context).game != null
                          ? () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SavedGamePage(),
                                  ));
                            }
                          : () {},
                      MediaQuery.of(context).size),
                  addVerticalSpace(20),
                  PrimaryButton(
                      const Text(
                        "New Game",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
                      ).tr(), () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NewGamePage(),
                        ));
                  }, MediaQuery.of(context).size)
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
