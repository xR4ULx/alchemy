import 'package:flutter_incall_manager/incall.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

typedef OnConnected();
typedef OnAssigned(String username);
typedef OnDisconnected(String username);

typedef OnRequest(String player1);
typedef OnResponse(bool response);
typedef OnChangeTurn(data);
typedef OnCancelRequest();
typedef OnExitGame();
typedef OnFinishGame();

class Signaling {
  IO.Socket _socket;
  OnConnected onConnected;
  OnRequest onRequest;
  OnResponse onResponse;
  OnChangeTurn onChangeTurn;
  OnCancelRequest onCancelRequest;
  OnFinishGame onFinishGame;
  OnExitGame onExitGame;
  IncallManager _incallManager = IncallManager();

  //IncallManager _incallManager = IncallManager();

  Signaling() {
    _connect();
  }

  _connect() {
    String uri = 'https://backgame.herokuapp.com';
    //String uri = 'http://192.168.1.41:5050';

    _socket = IO.io(uri, <String, dynamic>{
      'transports': ['websocket'],
    });

    _socket.on("on-connected", (_) {
      onConnected();
    });

    _socket.on('on-request', (player1) {
      _incallManager.startRingtone('DEFAULT', 'default', 10);
      onRequest(player1);
    });

    _socket.on('on-cancel-request', (value) {
      _incallManager.stopRingtone();
      onCancelRequest();
    });

    _socket.on('on-response', (response) {
      if (response) {
        _incallManager.start();
        _incallManager.setForceSpeakerphoneOn(flag: ForceSpeakerType.FORCE_ON);
      }
      onResponse(response);
    });

    _socket.on('on-changeTurn', (data) {
      onChangeTurn(data);
    });

    _socket.on('on-finish', (data) {
      _incallManager.stop();
      onFinishGame();
    });

    _socket.on('on-exit-game', (data) {
      onExitGame();
    });
  }

  acceptOrDecline(bool accept, String adversary) async {
    _incallManager.stopRingtone();
    if (accept) {
      _incallManager.start();
      _incallManager.setForceSpeakerphoneOn(flag: ForceSpeakerType.FORCE_ON);
      emit('response', {"displayName": adversary, "accept": true});
    } else {
      emit('response', {"displayName": adversary, "accept": false});
    }
  }

  emit(String event, dynamic data) {
    _socket?.emit(event, data);
  }

  dispose() {
    _incallManager.stop();
    _socket?.disconnect();
    _socket?.destroy();
    _socket = null;
  }
}
