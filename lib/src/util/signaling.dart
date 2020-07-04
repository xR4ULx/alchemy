import 'package:flutter_incall_manager/incall.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

typedef OnConnected();
typedef OnAssigned(String username);
typedef OnDisconnected(String username);

typedef OnRequest(String player1);
typedef OnResponse(bool response);
typedef OnChangeTurn(data);
typedef OnFinish();

class Signaling {
  IO.Socket _socket;
  OnConnected onConnected;
  OnRequest onRequest;
  OnResponse onResponse;
  OnChangeTurn onChangeTurn;
  OnFinish onFinish;

  IncallManager _incallManager = IncallManager();

  Signaling() {
    _connect();
  }

  _connect() {
    //String uri = 'https://backgame.herokuapp.com';
    String uriDev = 'http://192.168.1.41:5050';

    _socket = IO.io(uriDev, <String, dynamic>{
      'transports': ['websocket'],
    });

    _socket.on("on-connected", (_) {
      onConnected();
    });

    _socket.on('on-request', (player1) {
      _incallManager.start(
          media: MediaType.AUDIO, auto: false, ringback: '_DEFAULT_');
      onRequest(player1);
    });

    _socket.on('on-response', (response) {
      onResponse(response);
    });

    _socket.on('on-changeTurn', (data) {
      onChangeTurn(data);
    });

    _socket.on('on-finish', (data) {
      onFinish();
    });
  }

  acceptOrDecline(bool accept, String adversary) async {
    _incallManager.stopRingtone();
    if (accept) {
      emit('response', {"displayName": adversary, "accept": true});
      _incallManager.start();
      _incallManager.setForceSpeakerphoneOn(flag: ForceSpeakerType.FORCE_ON);
    } else {
      emit('response', {"displayName": adversary, "accept": false});
    }
  }

  finishGame() {
    _incallManager.stop();
    emit('finish', true);
  }

  emit(String event, dynamic data) {
    _socket?.emit(event, data);
  }

  dispose() {
    _socket?.disconnect();
    _socket?.destroy();
    _socket = null;
  }
}
