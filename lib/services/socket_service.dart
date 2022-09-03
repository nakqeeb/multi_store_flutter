import 'package:multi_store_app/utilities/global_variables.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketService {
  static late Socket socket;

  static void connect() async {
    socket = io(
        SOCKET_URL,
        OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build());
    socket.connect();
  }

  static void disConnect() {
    socket.disconnect()
      ..dispose()
      ..close();
  }
}
