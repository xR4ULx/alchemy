import 'package:flutter/material.dart';

class Potion {
  String player = '';

  Potion();

  bool setPosition(String player) {
    if (this.player == '') {
      this.player = player;
      return true;
    } else {
      if (player == 'p1win' || player == 'p2win') {
        this.player = player;
        return true;
      } else {
        return false;
      }
    }
  }

  Widget getPosition() {
    if (player == '') {
      return Text(
        '',
      );
    } else {
      if (player == 'p1' || player == 'p2') {
        return Image(
          image: AssetImage("assets/$player.png"),
          width: 50,
        );
      } else {
        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                offset: const Offset(0.0, 0.0),
                blurRadius: 20.0,
                spreadRadius: 3.0,
                color: (player == 'p1win') ? Color(0xFF70DCA9) : Colors.amber,
              )
            ],
          ),
          child: Image(
            image: AssetImage("assets/$player.png"),
            width: 50,
          ),
        );
      }
    }
  }
}

class Potions {
  final _rows = 6;
  final _cols = 6;

  List<List<Potion>> potions;

  Potion getPotion(int col, int row) {
    return potions[col][row];
  }

  Potions() {
    clearPotions();
  }

  clearPotions() {
    potions = new List.generate(_cols, (_) => new List(_rows));
    for (var c = 0; c < _cols; c++) {
      for (var r = 0; r < _rows; r++) {
        potions[c][r] = new Potion();
      }
    }
  }

  bool fullPotions() {
    for (var c = 0; c < _cols; c++) {
      for (var r = 0; r < _rows; r++) {
        if (potions[c][r].player == '') {
          return false;
        }
      }
    }
    return true;
  }
}
