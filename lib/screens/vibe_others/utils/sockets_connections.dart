import 'dart:io';

import 'package:web_socket_channel/web_socket_channel.dart';

Future<WebSocketChannel> connectToSocket(String uri) async {
  try {
    final WebSocketChannel channel = WebSocketChannel.connect(Uri.parse(uri));
    await channel.ready;
    return channel;
  } on SocketException {
    // Handle the exception.
    rethrow;
  } on WebSocketChannelException {
    // Handle the exception.
    rethrow;
  }
}
