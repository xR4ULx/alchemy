import 'package:alchemy/src/models/potion_model.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

class Coordenadas {
  int c;
  int r;
  Coordenadas(int col, int row) {
    this.c = col;
    this.r = row;
  }
}

class CheckWin {
  final _rows = 6;
  final _cols = 6;

  int winsPlayer;
  Potions _potions;
  String player;

  List<List<Coordenadas>> diagonales = [];

  List<Coordenadas> d1 = [
    new Coordenadas(0, 3),
    new Coordenadas(1, 2),
    new Coordenadas(2, 1),
    new Coordenadas(3, 0)
  ];

  List<Coordenadas> d2 = [
    new Coordenadas(0, 4),
    new Coordenadas(1, 3),
    new Coordenadas(2, 2),
    new Coordenadas(3, 1),
    new Coordenadas(4, 0),
  ];
  List<Coordenadas> d3 = [
    new Coordenadas(0, 5),
    new Coordenadas(1, 4),
    new Coordenadas(2, 3),
    new Coordenadas(3, 2),
    new Coordenadas(4, 1),
    new Coordenadas(5, 0),
  ];
  List<Coordenadas> d4 = [
    new Coordenadas(1, 5),
    new Coordenadas(2, 4),
    new Coordenadas(3, 3),
    new Coordenadas(4, 2),
    new Coordenadas(5, 1),
  ];
  List<Coordenadas> d5 = [
    new Coordenadas(2, 5),
    new Coordenadas(3, 4),
    new Coordenadas(4, 3),
    new Coordenadas(5, 2),
  ];
  List<Coordenadas> d6 = [
    new Coordenadas(0, 2),
    new Coordenadas(1, 3),
    new Coordenadas(2, 4),
    new Coordenadas(3, 5),
  ];
  List<Coordenadas> d7 = [
    new Coordenadas(0, 1),
    new Coordenadas(1, 2),
    new Coordenadas(2, 3),
    new Coordenadas(3, 4),
    new Coordenadas(4, 5),
  ];
  List<Coordenadas> d8 = [
    new Coordenadas(0, 0),
    new Coordenadas(1, 1),
    new Coordenadas(2, 2),
    new Coordenadas(3, 3),
    new Coordenadas(4, 4),
    new Coordenadas(5, 5),
  ];
  List<Coordenadas> d9 = [
    new Coordenadas(1, 0),
    new Coordenadas(2, 1),
    new Coordenadas(3, 2),
    new Coordenadas(4, 3),
    new Coordenadas(5, 4),
  ];
  List<Coordenadas> d10 = [
    new Coordenadas(2, 0),
    new Coordenadas(3, 1),
    new Coordenadas(4, 2),
    new Coordenadas(5, 3),
  ];

  CheckWin(String player, Potions potions, Animation colorAnimation) {
    winsPlayer = 0;
    this.player = player;
    this._potions = potions;
    diagonales.add(d1);
    diagonales.add(d2);
    diagonales.add(d3);
    diagonales.add(d4);
    diagonales.add(d5);
    diagonales.add(d6);
    diagonales.add(d7);
    diagonales.add(d8);
    diagonales.add(d9);
    diagonales.add(d10);
  }

  Future<String> comprobarWin() async {
    await comprobarWinCols();
    await comprobarWinRows();
    await comprobarWinDiag();
    //_resultDiag = await comprobarWinDiag();

    if (winsPlayer > 0) {
      return player;
    } else {
      return null;
    }
  }

  Future<void> comprobarWinCols() async {
    List<Coordenadas> winCols = [];

    for (var col = 0; col < _cols; col++) {
      for (var row = 0; row < _rows; row++) {
        Potion _potion = _potions.getPotion(col, row);

        if (_potion.player == this.player ||
            _potion.player == '${this.player}win') {
          winCols.add(new Coordenadas(col, row));
          if (winCols.length > 3) {
            break;
          }
        } else {
          winCols.clear();
        }
      }

      if (winCols.length > 3) {
        winsPlayer++;
        for (var item in winCols) {
          Potion potion = _potions.getPotion(item.c, item.r);
          potion.setPosition('${this.player}win');
          potion.getPosition();
        }
      }

      winCols.clear();
    }
  }

  Future<void> comprobarWinRows() async {
    List<Coordenadas> winRows = [];

    for (var col = 0; col < _cols; col++) {
      for (var row = 0; row < _rows; row++) {
        Potion _potion = _potions.getPotion(row, col);

        if (_potion.player == this.player ||
            _potion.player == '${this.player}win') {
          winRows.add(new Coordenadas(row, col));
          if (winRows.length > 3) {
            break;
          }
        } else {
          winRows.clear();
        }
      }

      if (winRows.length > 3) {
        winsPlayer++;
        for (var item in winRows) {
          Potion potion = _potions.getPotion(item.c, item.r);
          potion.setPosition('${this.player}win');
          potion.getPosition();
        }
      }

      winRows.clear();
    }
  }

  Future<void> comprobarWinDiag() async {
    List<Coordenadas> winDiag = [];
    winDiag.clear();

    for (var diag in diagonales) {
      for (Coordenadas item in diag) {
        Potion _potion = _potions.getPotion(item.c, item.r);

        if (_potion.player == this.player ||
            _potion.player == '${this.player}win') {
          winDiag.add(new Coordenadas(item.c, item.r));
          if (winDiag.length > 3) {
            break;
          }
        } else {
          winDiag.clear();
        }
      }

      if (winDiag.length > 3) {
        winsPlayer++;
        for (var item in winDiag) {
          Potion potion = _potions.getPotion(item.c, item.r);
          potion.setPosition('${this.player}win');
          potion.getPosition();
        }
      }

      winDiag.clear();
    }
  }
}
