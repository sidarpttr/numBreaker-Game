import 'package:flutter/material.dart';
import 'package:num_breaker/constants/theme/colors.dart';
import 'package:num_breaker/constants/theme/theme.dart';
import 'package:num_breaker/data/models/gameStatus.dart';
import 'package:num_breaker/data/models/numberCard.dart';
import 'package:num_breaker/data/services/game.dart';
import 'package:num_breaker/providers/gameProvider.dart';
import 'package:num_breaker/providers/themeProvider.dart';
import 'package:provider/provider.dart';

class GameContent extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;
  final bool newGame;
  const GameContent(
      {super.key,
      required this.screenHeight,
      required this.screenWidth,
      required this.newGame});

  @override
  State<GameContent> createState() => _GameContentState();
}

const double iskartaBarHeight = 200;

class _GameContentState extends State<GameContent> {
  late GameStatus gameStatus;

  late bool tahmin_yapilabilir;
  late double card_size;

  @override
  void initState() {
    super.initState();
    card_size = widget.screenWidth / 9;
    tahmin_yapilabilir = false;
    if (widget.newGame) {
      gameStatus = GameStatus(
          game: Game(),
          screenHeight: widget.screenHeight,
          screenWidth: widget.screenWidth);
    } else {
      final gameString = Provider.of<GameProvider>(context, listen: false).game;
      gameStatus = GameStatus.fromJson(gameString!);
    }
  }

  void removeIskarta(Item item, Offset newPos) {
    setState(() {
      gameStatus.iskartadakiler![
          gameStatus.iskartadakiler!.indexOf(item.number)] = -1;
      item.position = newPos;
    });
  }

  void addIskarta(Item item) {
    setState(() {
      for (int i = 0; i < 6; i++) {
        if (gameStatus.iskartadakiler![i] == -1) {
          item.position = gameStatus.iskarta[i];
          gameStatus.iskartadakiler![i] = item.number;
          break;
        }
      }
    });
  }

  void moveItem(Item item, Offset newPosition) async {
    int index = item.number;
    double stackTopPadding = card_size;
    double stackLeftPadding = 0.0;

    final double newTop = newPosition.dy - stackTopPadding;
    final double newLeft = newPosition.dx - stackLeftPadding;

    Offset newPos = Offset(newLeft, newTop);

    setState(() {
      if (newPos.dy > MediaQuery.of(context).size.height / 10) {
        //üst sınır

        //her türlü kesişme önlenecek
        for (int i = 0; i < 10; i++) {
          if (i != item.number &&
              gameStatus.isOverlapping(item,
                  Item(number: 11, position: gameStatus.items![i].position))) {
                    return;
                  }
        }

        if (item.position.dy < MediaQuery.of(context).size.height / 10) {
          //tahminden çıkıyorsa
          gameStatus.tahminler![gameStatus.tahminler!.indexOf(item.number)] =
              -1;
        }

        if (newPos.dy > widget.screenHeight - 200) {
          //ıskartaya çıkmış olanlar

          if (gameStatus.iskartadakiler!.contains(item.number)) {
            //ıskartada yer değişikliği
            return;
          }

          if (gameStatus.iskartadakiler!.every((e) => e >= 0)) {
            //ıskarta dolu ise
            return;
          }

          addIskarta(item);
          //ıskartaya eklenebilir
        } else {
          if (gameStatus.iskartadakiler!.contains(item.number)) {
            //iskartadan çıkıyorsa

            removeIskarta(item, newPos);
          }

          for (var _ in gameStatus.items!) {
            Offset originalPosition = gameStatus.items![index].position;
            gameStatus.items![index].position = newPos;

            // Diğer tüm öğelerle kesişme kontrolü yap
            for (var i = 0; i < gameStatus.items!.length; i++) {
              if (i != index &&
                  gameStatus.isOverlapping(item, gameStatus.items![i])) {
                // Eğer kesişme varsa, öğeyi orijinal konumuna geri taşı
                gameStatus.items![index].position = originalPosition;
                break;
              }
            }
          }
        }
      } else {
        // tahmine girecek

        int? index;
        for (int i = 0; i < 4; i++) {
          //kesişen bölgenin indexi
          if (gameStatus.isOverlapping(
              Item(number: 1, position: gameStatus.tahminPos[i]),
              Item(number: 1, position: newPos))) {
            index = i;
          }
        }

        if (index == null) {
          return;
        }

        // bölgede taş varsa indexi yoksa -1
        int value = gameStatus.tahminler![index];

        if (value >= 0) {
          //bölge doluysa

          if (gameStatus.tahminler!.contains(item.number)) {
            //zaten tahminler!deyse

            //tahminler! dizisi güncelleme
            int itemIndex = gameStatus.tahminler!.indexOf(item.number);
            int targetIndex = gameStatus.tahminler!.indexOf(value);
            gameStatus.tahminler![itemIndex] = value;
            gameStatus.tahminler![targetIndex] = item.number;

            //konumları değiştir
            Offset tempPos = item.position;
            item.position = gameStatus.tahminPos[index];
            gameStatus.items![value].position = tempPos;

            return;
          }

          //boş bir konum bul
          index = gameStatus.tahminler!.indexWhere((element) => element < 0);
          if (index == -1) {
            return;
          }

          item.position = gameStatus.tahminPos[index];
          gameStatus.tahminler![index] = item.number;
        } else {
          //boşsa

          if (gameStatus.tahminler!.contains(item.number)) {
            //zaten tahminlerdeyse
            int itemIndex = gameStatus.tahminler!.indexOf(item.number);
            gameStatus.tahminler![itemIndex] = -1;
            gameStatus.tahminler![index] = item.number;

            item.position = gameStatus.tahminPos[index];

            return;
          }

          //arenadan tahmine gönderdik
          item.position = gameStatus.tahminPos[index];
        }

        item.position = gameStatus.tahminPos[index];
        gameStatus.tahminler![index] = item.number;
      }

      tahmin_yapilabilir = !gameStatus.tahminler!.any((element) => element < 0);
    });

    print(gameStatus.tahminler);
    await Provider.of<GameProvider>(context, listen: false)
        .updateGame(gameStatus);
  }

  void postNumber() async {
    setState(() {
      gameStatus.getResult();
    });

    await Provider.of<GameProvider>(context, listen: false)
        .updateGame(gameStatus);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context).themeData;
    return Scaffold(
      backgroundColor: theme == darkTheme ? COLOR_DARKER : COLOR_SECONDARY,
      body: Stack(
        children: [
              Positioned(
                  top: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 10 + 40,
                    color: theme == darkTheme ? DARK_SCAFFOLD_BG : SCAFFOLD_BG,
                    child: Stack(
                      children: List.generate(
                              4,
                              (index) => Positioned(
                                    top: gameStatus.tahminPos[index].dy,
                                    left: gameStatus.tahminPos[index].dx,
                                    child: Container(
                                      width: card_size,
                                      height: card_size,
                                      decoration: BoxDecoration(
                                        color: theme == darkTheme
                                            ? GREY
                                            : COLOR_SECONDARY,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                    ),
                                  )) +
                          [
                            Positioned(
                              top: gameStatus.tahminPos[0].dy,
                              right: gameStatus.tahminPos[0].dx,
                              child: GestureDetector(
                                onTap: !tahmin_yapilabilir
                                    ? null
                                    : () {
                                        postNumber();
                                      },
                                child: Container(
                                  width: card_size * 1.5,
                                  height: card_size,
                                  decoration: BoxDecoration(
                                      gradient: tahmin_yapilabilir
                                          ? const LinearGradient(colors: [
                                              COLOR_PRIMARY,
                                              COLOR_DARKER
                                            ])
                                          : null,
                                      color: !tahmin_yapilabilir
                                          ? COLOR_SECONDARY
                                          : null,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(13)),
                                      border: !tahmin_yapilabilir
                                          ? Border.all(color: COLOR_PRIMARY)
                                          : null),
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    color: tahmin_yapilabilir
                                        ? Colors.white
                                        : COLOR_DARKER,
                                  ),
                                ),
                              ),
                            )
                          ],
                    ),
                  )),
              Positioned(
                  top: MediaQuery.of(context).size.height / 10,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 5,
                    alignment: Alignment.topCenter,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 100),
                    decoration: BoxDecoration(
                        color:
                            theme == darkTheme ? COLOR_DARKER : COLOR_PRIMARY,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(34))),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                          children: gameStatus.tahmin_gecmisi!.entries
                              .map((e) => ListTile(
                                    title: Text(
                                      e.key.toString(),
                                      style: const TextStyle(
                                          color: COLOR_SECONDARY,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    trailing: Text(
                                      e.value,
                                      style: const TextStyle(
                                          color: COLOR_SECONDARY,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ))
                              .toList()
                              .reversed
                              .toList()),
                    ),
                  )),
              Positioned(
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: iskartaBarHeight,
                  decoration: BoxDecoration(
                      color:
                          theme == darkTheme ? DARK_SCAFFOLD_BG : COLOR_DARKER,
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, -2))
                      ],
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(34))),
                  alignment: Alignment.center,
                  child: Stack(
                      children: List.generate(
                    6,
                    (index) => Positioned(
                      top: gameStatus.iskarta[index].dy -
                          widget.screenHeight +
                          iskartaBarHeight,
                      left: gameStatus.iskarta[index].dx,
                      child: Container(
                        width: card_size,
                        height: card_size,
                        decoration: BoxDecoration(
                          color: theme == darkTheme
                              ? GREY
                              : Colors.black.withAlpha(100),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                  )),
                ),
              )
            ] +
            gameStatus.items!
                .map((item) => Positioned(
                      top: item.position.dy,
                      left: item.position.dx,
                      child: Draggable(
                        data: item,
                        feedback: Material(
                          borderRadius: BorderRadius.circular(10),
                          elevation: 4.0,
                          child: NCard(card_size, item.number),
                        ),
                        childWhenDragging: Container(),
                        onDragEnd: (details) => moveItem(item, details.offset),
                        child: NCard(card_size, item.number),
                      ),
                    ))
                .toList(),
      ),
    );
  }
}

Widget NCard(double size, int number) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withAlpha(80),
              offset: const Offset(1, 1),
              blurRadius: 2)
        ]),
    child: Center(
      child: Text(
        number.toString(),
        style: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 25, color: Colors.black),
      ),
    ),
  );
}
