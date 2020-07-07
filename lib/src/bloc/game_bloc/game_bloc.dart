import 'dart:async';

import 'package:alchemy/src/bloc/game_bloc/bloc.dart';
import 'package:alchemy/src/repository/user_model.dart';
import 'package:alchemy/src/util/signaling.dart';
import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  @override
  GameState get initialState => SHome();

  Signaling _signaling = GetIt.I.get<Signaling>();
  User _user = GetIt.I.get<User>();

  GameBloc() {
    _init();
  }

  _init() async {
    _signaling.onRequest = (adversary) {
      _user.adversary = adversary;
      add(ERequest());
    };

    _signaling.onCancelRequest = () {
      _user.player = '';
      _user.adversary = '';
      add(EHome());
    };

    _signaling.onResponse = (response) {
      if (response) {
        _user.player = 'p1';
        add(EGame());
      } else {
        add(EHome());
      }
    };
  }

  @override
  Stream<GameState> mapEventToState(
    GameEvent event,
  ) async* {
    if (event is EHome) {
      yield* _mapHomeToState();
    }
    if (event is EWait) {
      yield* _mapWaitToState();
    }
    if (event is ERequest) {
      yield* _mapRequestToState();
    }
    if (event is EGame) {
      yield* _mapGameToState();
    }
  }

  Stream<GameState> _mapHomeToState() async* {
    yield SHome();
  }

  Stream<GameState> _mapWaitToState() async* {
    yield SWait();
  }

  Stream<GameState> _mapRequestToState() async* {
    yield SRequest();
  }

  Stream<GameState> _mapGameToState() async* {
    yield SGame();
  }
}
