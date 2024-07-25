import 'package:flutter/material.dart';

class PageIndexProvider extends ChangeNotifier{

  int _currentIndex = 0;

  int get currenIndex => _currentIndex;

  set currentIndex(int value){
    _currentIndex = value;
    notifyListeners();
  }

}