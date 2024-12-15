import 'package:web_socket_channel/web_socket_channel.dart';

class ReverbService {
  final WebSocketChannel channel;

  ReverbService(String url)
      : channel = WebSocketChannel.connect(Uri.parse(url));

  Stream<dynamic> get events => channel.stream;

  void sendMessage(String message) {
    channel.sink.add(message);
  }

  void dispose() {
    channel.sink.close();
  }
}
