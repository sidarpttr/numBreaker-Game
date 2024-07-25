import 'dart:math';

class Game {
  late List<int>? number;

  //oyun başlar rastgele sayı atanır
  Game({this.number}) {
    if(number != null){
      return;
    }
    while (true) {
      number = List.generate(
          4,
          (index) =>
              index == 0 ? Random().nextInt(9) + 1 : Random().nextInt(10));
      if (number!.toSet().length == 4) {
        break;
      }
    }
  }

  factory Game.fromNumber(List<int> number){
    return Game(number: number);
  }

  List<int> getResult(List<int> _number) {
    int dogru_sayilar = 0;
    int dogru_hiza = 0;

    for (int i = 0; i < 4; i++) {
      if (number!.contains(_number[i])) {
        dogru_sayilar++;

        if (number![i] != _number[i]) {
          dogru_hiza--;
        }
      }
    }

    return [dogru_sayilar, dogru_hiza];
  }
}
