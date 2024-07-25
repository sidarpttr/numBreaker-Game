import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:num_breaker/constants/theme/colors.dart';
import 'package:num_breaker/constants/theme/theme.dart';
import 'package:num_breaker/presentation/pages/leaderboard.dart';
import 'package:num_breaker/presentation/pages/menu.dart';
import 'package:num_breaker/presentation/pages/profile.dart';
import 'package:num_breaker/providers/pageIndex.dart';
import 'package:num_breaker/providers/themeProvider.dart';
import 'package:num_breaker/utils/hellper.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

List<Widget> body = const [MenuPage(), LeaderboardPage(), ProfilePage()];

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("NumBreaker"),
        actions: [
          ElevatedButton(
            onPressed: () {

            },
            style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(COLOR_DARKER),
                foregroundColor: MaterialStatePropertyAll(COLOR_SECONDARY),
                padding: MaterialStatePropertyAll(EdgeInsetsDirectional.zero)),
            child: const Icon(Icons.language),
          ),
          addHorizontalSpace(20),
          Switch(
              value: theme.themeData == darkTheme,
              onChanged: (value) => theme.toggleTheme(),
              activeColor: COLOR_DARKER,
              activeTrackColor: GREY,
              inactiveTrackColor: COLOR_SECONDARY,
              inactiveThumbColor: COLOR_DARKER),
          addHorizontalSpace(20)
        ],
      ),
      body: body[Provider.of<PageIndexProvider>(context).currenIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          height: 56,
          child: GNav(
            tabs: [
              GButton(
                padding: const EdgeInsets.all(14),
                iconColor: COLOR_DARKER,
                gap: 10,
                textColor: Colors.white,
                iconActiveColor: Colors.white,
                backgroundGradient:
                    const LinearGradient(colors: [COLOR_DARKER, COLOR_PRIMARY]),
                icon: Icons.home,
                text: "Home",
                onPressed: () {
                  Provider.of<PageIndexProvider>(context, listen: false)
                      .currentIndex = 0;
                },
              ),
              GButton(
                padding: const EdgeInsets.all(14),
                iconColor: COLOR_DARKER,
                gap: 10,
                textColor: Colors.white,
                iconActiveColor: Colors.white,
                backgroundGradient:
                    const LinearGradient(colors: [COLOR_DARKER, COLOR_PRIMARY]),
                icon: Icons.leaderboard,
                text: "Leaderboard",
                onPressed: () {
                  Provider.of<PageIndexProvider>(context, listen: false)
                      .currentIndex = 1;
                },
              ),
              GButton(
                padding: const EdgeInsets.all(14),
                iconColor: COLOR_DARKER,
                gap: 10,
                textColor: Colors.white,
                iconActiveColor: Colors.white,
                backgroundGradient:
                    const LinearGradient(colors: [COLOR_DARKER, COLOR_PRIMARY]),
                icon: Icons.person,
                text: "Me",
                onPressed: () {
                  Provider.of<PageIndexProvider>(context, listen: false)
                      .currentIndex = 2;
                },
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceAround,
          ),
        ),
      ),
    );
  }
}
