import 'dart:async';

import 'package:alchemy/src/bloc/game_bloc/bloc.dart';
import 'package:alchemy/src/util/signaling.dart';
import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';


class GameBloc extends Bloc<GameEvent, GameState> {

  @override
  GameState get initialState => SHome();

  Signaling _signaling = GetIt.I.get<Signaling>();
  
  GameBloc() {
    _init();
  }

  _init() async {

    _signaling.onRequest = (gameid) {
      add(ERequest());
    };

    _signaling.onResponse = (response){
      if(response){
        add(EGame());
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
