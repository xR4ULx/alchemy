import 'package:equatable/equatable.dart';

abstract class GameEvent extends Equatable {
  GameEvent();

  @override
  List<Object> get props => [];
}

// Cuatro eventos:
class EHome extends GameEvent {}

class EWait extends GameEvent {}

class ERequest extends GameEvent {}

class EGame extends GameEvent {}
