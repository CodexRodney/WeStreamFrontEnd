import 'package:flutter/material.dart';
import 'package:westreamfrontend/screens/vibe_others/models/chat_model.dart';

class ChatsProvider with ChangeNotifier {
  List<ChatModel> chats = [];

  void updateChats(ChatModel chat) {
    chats.add(chat);
    notifyListeners();
  }
}
