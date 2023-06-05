import 'package:flutter/material.dart';

abstract class HomeState {}

class HomeGroupsState implements HomeState {}

class HomeMapsState implements HomeState {}

class HomeControler extends ValueNotifier<HomeState> {
  HomeControler() : super(HomeGroupsState());

  onItemTapped(int index) {
    switch (index) {
      case 0:
        value = HomeGroupsState();
        break;
      case 1:
        value = HomeMapsState();
        break;
    }
  }
}
