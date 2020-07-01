

import 'package:socket_io_client/socket_io_client.dart' as IO;

typedef OnConnected();
typedef OnAssigned(String username);
typedef OnDisconnected(String username);

typedef OnRequest(String player1);
typedef OnResponse(bool response);

class Signaling {

  IO.Socket _socket;
  OnConnected onConnected;
  OnRequest onRequest;
  OnResponse onResponse;

  Signaling(){
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
      onRequest(player1);
    });

    _socket.on('on-response', (response) {
      onResponse(response);
    });

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
