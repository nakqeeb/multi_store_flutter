/* import 'dart:async';
import 'package:multi_store_app/providers/product_provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

// STEP1:  Stream setup
class StreamSocket {
  final _socketResponse = StreamController<ProductProvider>();

  void Function(ProductProvider) get addResponse => _socketResponse.sink.add;

  Stream<ProductProvider> get getResponse => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
  }
}

StreamSocket streamSocket = StreamSocket();

//STEP2: Add this function in main function in main.dart file and add incoming data to the stream
void connectAndListen() {
  IO.Socket socket = IO.io('http://192.168.0.111:3000',
      OptionBuilder().setTransports(['websocket']).build());

  socket.onConnect((_) {
    print('connect');
    socket.emit('msg', 'test');
  });

  //When an event recieved from server, data is added to the stream
  socket.on('products', (data) => streamSocket.addResponse);
  socket.onDisconnect((_) => print('disconnect'));
}
 */