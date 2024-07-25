// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:ui';

class Item {
  int number;
  Offset position;
  Item({
    required this.number,
    required this.position,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'number': number,
      'position': [position.dx, position.dy],
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      number: map['number'] as int,
      position: Offset(map["position"][0], map["position"][1]),
    );
  }

  String toJson() => json.encode(toMap());

  factory Item.fromJson(String source) => Item.fromMap(json.decode(source) as Map<String, dynamic>);
}
