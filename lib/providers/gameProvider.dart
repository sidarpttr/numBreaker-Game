import 'package:flutter/material.dart';
import 'package:num_breaker/data/models/gameStatus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameProvider extends ChangeNotifier {
  String? _game;
  GameProvider(this._game);

  String? get game => _game;

  Future<void> updateGame(GameStatus newGameStatus) async {
    _game = newGameStatus.toJson();
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastGame', _game!);
  }

  Future<void> loadGame() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? gameJson = prefs.getString('lastGame');
    if (gameJson != null) {
      _game = gameJson;
    } else {
      _game = null;
    }
    notifyListeners();
  }
}
