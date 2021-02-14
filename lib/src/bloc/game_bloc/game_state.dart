import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class GameState extends Equatable {
  GameState();
  List<Object> get props => [];
}

class SHome extends GameState {
  @override
  String toString() => 'In Home';
}

class SWait extends GameState {
  @override
  String toString() => 'In Wait';
}

class SRequest extends GameState {
  @override
  String toString() => 'In Request';
}

class SGame extends GameState {
  @override
  String toString() => 'In Game';
}

class SChat extends GameState {
  final String peerId;
  final String peerAvatar;
  SChat({@required this.peerId, @required this.peerAvatar});
  @override
  String toString() => 'In Chat';
}
