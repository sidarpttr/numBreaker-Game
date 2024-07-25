import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:num_breaker/app.dart';
import 'package:num_breaker/constants/appConstants.dart';
import 'package:num_breaker/constants/theme/theme.dart';
import 'package:num_breaker/providers/gameProvider.dart';
import 'package:num_breaker/providers/pageIndex.dart';
import 'package:num_breaker/providers/themeProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isDarkMode = prefs.getBool('isDarkMode') ?? false;
  ThemeData initialTheme = isDarkMode ? darkTheme : lightTheme;

  GameProvider gameProvider = GameProvider(null);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<PageIndexProvider>(
        create: (_) => PageIndexProvider(),
      ),
      ChangeNotifierProvider<ThemeProvider>(
          create: (_) => ThemeProvider(initialTheme)),
      ChangeNotifierProvider<GameProvider>(create: (_) => gameProvider)
    ],
    child: FutureBuilder(
      future: gameProvider
          .loadGame(), // GameProvider içindeki loadGame metodunu çağır
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return EasyLocalization(supportedLocales: const [
            AppConstants.EN_LOCALE,
            AppConstants.TR_LOCALE
          ], path: AppConstants.LANG_PATH, child: const MyApp());
        } else {
          // Yükleme sırasında bir yükleme ekranı göster
          return const CircularProgressIndicator();
        }
      },
    ),
  ));

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      title: "NumBreaker",
      routes: {'/': (context) => const HomePage()},
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
