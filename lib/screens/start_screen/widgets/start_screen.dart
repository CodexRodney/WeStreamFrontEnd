import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:westreamfrontend/screens/vibe_others/utils/sockets_connections.dart';
import 'package:westreamfrontend/screens/vibe_others/widgets/vibe_others_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              WebSocketChannel channel = await connectToSocket(
                "ws://127.0.0.1:8080/join-room/6589199356204844921",
              );
              if (!context.mounted) return;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VibeOthersScreen(channel: channel),
                ),
              );
            },
            child: Text("Connect To A Server"),
          ),
        ],
      ),
    );
  }
}
