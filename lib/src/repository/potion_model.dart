import 'package:flutter/material.dart';

class Coordenadas {
  int c;
  int r;
  Coordenadas(int col, int row) {
    this.c = col;
    this.r = row;
  }
}

class Potions {
  final _rows = 6;
  final _cols = 6;

  List<List<Potion>> _potions;

  Potions() {
    clearPotions();
  }

  clearPotions() {
    _potions = new List.generate(_cols, (_) => new List(_rows));
    for (var c = 0; c < _cols; c++) {
      for (var r = 0; r < _rows; r++) {
        _potions[c][r] = new Potion();
      }
    }
  }

  bool fullPotions() {
    for (var c = 0; c < _cols; c++) {
      for (var r = 0; r < _rows; r++) {
        if (_potions[c][r]._player == '') {
          return false;
        }
      }
    }
    return true;
  }

  getPotions() {
    return _potions;
  }

  String comprobarWin(String player) {
    if (comprobarWinCols(player) != null) {
      return player;
    } else if (comprobarWinRows(player) != null) {
      return player;
    } else {
      return null;
    }
  }

  String comprobarWinCols(String player) {
    for (var i = 0; i < _cols; i++) {
      if (comprobarWinCol(i, player) != null) {
        return player;
      }
    }

    return null;
  }

  String comprobarWinCol(int col, String player) {
    List<Coordenadas> win = [];
    win.clear();

    for (var r = 0; r < _rows; r++) {
      if (_potions[col][r]._player == player) {
        Coordenadas coor = new Coordenadas(col, r);
        win.add(coor);
        if (win.length > 3) {
          break;
        }
      } else {
        win.clear();
      }
    }

    if (win.length > 3) {
      return player;
    } else {
      return null;
    }
  }

  String comprobarWinRows(String player) {
    for (var i = 0; i < _rows; i++) {
      if (comprobarWinRow(i, player) != null) {
        return player;
      }
    }

    return null;
  }

  String comprobarWinRow(int row, String player) {
    List<Coordenadas> win = [];
    win.clear();

    for (var c = 0; c < _cols; c++) {
      if (_potions[c][row]._player == player) {
        Coordenadas coor = new Coordenadas(c, row);
        win.add(coor);
        if (win.length > 3) {
          break;
        }
      } else {
        win.clear();
      }
    }

    if (win.length > 3) {
      return player;
    } else {
      return null;
    }
  }
}

class Potion {
  String _player;

  Potion() {
    _player = '';
  }

  bool setPosition(String player) {
    if (_player == '') {
      this._player = player;
      return true;
    } else {
      return false;
    }
  }

  Widget getPosition() {
    switch (_player) {
      case '':
        return Text('');
        break;
      case 'p1':
        return Image(
          image: AssetImage("assets/p1.png"),
          width: 50,
        );
        break;
      case 'p2':
        return Image(
          image: AssetImage("assets/p2.png"),
          width: 50,
        );
        break;
      default:
        return Text('');
    }
  }
}
