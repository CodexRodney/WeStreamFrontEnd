import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:westreamfrontend/screens/start_screen/widgets/start_screen.dart';
import 'package:westreamfrontend/screens/vibe_others/providers/chats_provider.dart';
import 'package:westreamfrontend/screens/vibe_others/providers/music_streamer_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ChatsProvider()),
        ChangeNotifierProvider(create: (context) => MusicStreamerProvider()),
      ],

      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const StartScreen(),
      ),
    );
  }
}
