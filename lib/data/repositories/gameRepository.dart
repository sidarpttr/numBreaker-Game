import 'package:num_breaker/data/models/gameStatus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameRepository {
  static void SaveGame(GameStatus gameStatus) async {
    String game = gameStatus.toJson();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("LastGame", game);
  }
}
