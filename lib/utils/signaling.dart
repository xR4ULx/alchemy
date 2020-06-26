

import 'package:socket_io_client/socket_io_client.dart' as IO;

typedef OnConnected();
typedef OnAssigned(String username);
typedef OnDisconnected(String username);

typedef OnResponse(dynamic data);
typedef OnRequest(String him);

class Signaling {

  IO.Socket _socket;
  OnConnected onConnected;
  OnAssigned onAssigned;
  OnDisconnected onDisconnected;

  OnResponse onResponse;
  OnRequest onRequest;


  Future<void> init() async {
    _connect();
  }

  _connect() {
    String uri = 'https://backgame.herokuapp.com';
    //String uriDev = 'http://192.168.1.41:5050';

    _socket = IO.io(uri, <String, dynamic>{
      'transports': ['websocket'],
    });

    _socket.on("on-connected", (_) {
      onConnected();
    });

    _socket.on('on-assigned', (username) {
      onAssigned(username);
    });

    _socket.on('on-disconnected', (username) {
      onDisconnected(username);
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
