import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

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

class EChat extends GameEvent {
  final String peerId;
  final String peerAvatar;
  EChat({@required this.peerId, @required this.peerAvatar});
}
