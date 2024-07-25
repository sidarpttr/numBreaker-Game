import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:num_breaker/data/models/numberCard.dart';
import 'package:num_breaker/data/services/game.dart';

class GameStatus {
  List<Offset> iskarta = [];
  List<Item>? items = [];
  List<int>? iskartadakiler = [];

  List<Offset> tahminPos = [];
  List<int>? tahminler = [];

  Map<int, String>? tahmin_gecmisi = {};

  final double screenHeight;
  final double screenWidth;

  Game? game;

  GameStatus(
      {this.items,
      this.iskartadakiler,
      this.tahminler,
      this.tahmin_gecmisi,
      required this.screenHeight,
      required this.screenWidth,
      this.game}) {
    double card_size = screenWidth / 9;
    iskartadakiler = iskartadakiler ?? [];
    tahminler = tahminler ?? [];
    tahmin_gecmisi = tahmin_gecmisi ?? {};
    iskarta = List.generate(
        6,
        (index) => Offset(
            ((index % 3) * card_size * 2 + (screenWidth - card_size * 5) / 2),
            screenHeight - 200 + index ~/ 3 * card_size * 1.5 + 40));

    tahminPos = List.generate(
        4,
        (index) => Offset(
            index * card_size * 1.5 + (screenWidth - 8 * card_size) / 2,
            (screenHeight / 10 - card_size) / 2));

    items = items ??
        List.generate(10, (index) {
          if (iskartadakiler!.contains(index)) {
            return Item(
                number: index,
                position: iskarta[iskartadakiler!.indexOf(index)]);
          } else if (tahminler != null && tahminler!.contains(index)) {
            return Item(
                number: index, position: tahminPos[tahminler!.indexOf(index)]);
          }
          return Item(
              number: index,
              position: Offset(((index % 3) * 75 + (screenWidth - 200) / 2),
                  index ~/ 3 * 75 + screenHeight / 3));
        });

    //ıskarta listesi oluştur
    for (int i = iskartadakiler!.length - 1; i < 6; i++) {
      iskartadakiler!.add(-1);
    }

    //tahmin listesi oluştur
    for (int i = tahminler!.length; i < 4; i++) {
      tahminler!.add(-1);
    }
    game = Game();
  }

  bool isOverlapping(Item item1, Item item2) {
    double width = 50.0;
    double height = 50.0;

    double item1Left = item1.position.dx;
    double item1Right = item1.position.dx + width;
    double item1Top = item1.position.dy;
    double item1Bottom = item1.position.dy + height;

    double item2Left = item2.position.dx;
    double item2Right = item2.position.dx + width;
    double item2Top = item2.position.dy;
    double item2Bottom = item2.position.dy + height;

    return !(item1Right < item2Left ||
        item1Left > item2Right ||
        item1Bottom < item2Top ||
        item1Top > item2Bottom);
  }

  void getResult() {
    List<int> result = game!.getResult(tahminler!);

    int sayi = 0;
    for (int i = 0; i < 4; i++) {
      sayi += tahminler![i] * pow(10, 3 - i).toInt();
    }
    String ipucu = "${result[0]} ${result[1]}";

    tahmin_gecmisi![sayi] = ipucu;
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'items': items!.map((x) => x.toMap()).toList(),
      'iskartadakiler': iskartadakiler,
      'tahminler': tahminler,
      'screenHeight': screenHeight,
      'screenWidth': screenWidth,
      'tahmin_gecmisi':
          tahmin_gecmisi!.map((key, value) => MapEntry(key.toString(), value)),
      "game": game!.number
    };
  }

  String toJson() {
    return json.encode(toMap());
  }

  factory GameStatus.fromJson(String source) {
    return GameStatus.fromMap(json.decode(source) as Map<String, dynamic>);
  }

  factory GameStatus.fromMap(Map<String, dynamic> map) {
    return GameStatus(
      screenHeight: map['screenHeight'] as double,
      screenWidth: map['screenWidth'] as double,
      items: List<Item>.from((map['items'] as List<dynamic>).map<Item>(
        (x) => Item.fromMap(x as Map<String, dynamic>),
      )),
      iskartadakiler: (map['iskartadakiler'] as List<dynamic>)
          .map<int>((x) => x as int)
          .toList(),
      tahminler: (map['tahminler'] as List<dynamic>)
          .map<int>((x) => x as int)
          .toList(),
      tahmin_gecmisi:
          (map['tahmin_gecmisi'] as Map<String, dynamic>).map<int, String>(
        (key, value) => MapEntry(int.parse(key), value),
      ),
      game: Game.fromNumber(map["game"]!.map<int>((e) => e as int).toList()),
    );
  }
}
