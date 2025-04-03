import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:westreamfrontend/screens/vibe_others/models/chat_model.dart';
import 'package:westreamfrontend/screens/vibe_others/providers/chats_provider.dart';
import 'package:westreamfrontend/screens/vibe_others/widgets/chat_widget.dart';

class VibeOthersScreen extends StatefulWidget {
  const VibeOthersScreen({super.key, required this.channel});

  final WebSocketChannel channel;

  @override
  State<VibeOthersScreen> createState() => _VibeOthersScreenState();
}

class _VibeOthersScreenState extends State<VibeOthersScreen> {
  final TextEditingController _sendMessageController = TextEditingController();

  @override
  void initState() {
    widget.channel.stream.listen((event) {
      if (!mounted) {
        return;
      }
      context.read<ChatsProvider>().updateChats(
        ChatModel(message: event, isReceived: true),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.25,
                  color: Colors.purple,
                ),
                Expanded(child: Container(color: Colors.orange)),
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  color: Colors.white,
                  child: Column(
                    children: [
                      Text("ROOM CHAT", style: TextStyle(fontSize: 24)),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        color: Colors.blue,
                      ),
                      Expanded(
                        child: Consumer<ChatsProvider>(
                          builder:
                              (context, value, _) => ListView.builder(
                                itemBuilder:
                                    (context, index) => ChatWidget(
                                      label: value.chats[index].message,
                                      isReceived: value.chats[index].isReceived,
                                    ),
                                itemCount: value.chats.length,
                              ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.emoji_emotions_outlined),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.22,
                              child: TextField(
                                controller: _sendMessageController,
                                decoration: InputDecoration(
                                  label: const Text(
                                    "Type Message",
                                    textAlign: TextAlign.center,
                                  ),
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                if (_sendMessageController.text.isNotEmpty) {
                                  String message = _sendMessageController.text;
                                  widget.channel.sink.add(message);
                                  _sendMessageController.clear();
                                  context.read<ChatsProvider>().updateChats(
                                    ChatModel(
                                      message: message,
                                      isReceived: false,
                                    ),
                                  );
                                }
                              },
                              icon: Icon(Icons.send),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    widget.channel.sink.close();
    _sendMessageController.dispose();
    super.dispose();
  }
}
