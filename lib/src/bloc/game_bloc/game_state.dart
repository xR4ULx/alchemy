

import 'package:equatable/equatable.dart';

abstract class GameState extends Equatable {
  const GameState();
  List<Object> get props => [];

}

class SHome extends GameState{
  @override
  String toString() => 'In Home';
}

class SWait extends GameState{
  @override
  String toString() => 'In Wait';
}

class SRequest extends GameState{
  @override
  String toString() => 'In Request';
}

class SGame extends GameState{
  @override
  String toString() => 'In Game';
}
