import 'dart:io';

import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:westreamfrontend/screens/start_screen/services/room_services.dart';
import 'package:westreamfrontend/screens/vibe_others/models/chat_model.dart';
import 'package:westreamfrontend/screens/vibe_others/providers/chats_provider.dart';
import 'package:westreamfrontend/screens/vibe_others/providers/music_streamer_provider.dart';
import 'package:westreamfrontend/screens/vibe_others/widgets/chat_widget.dart';

class VibeOthersScreen extends StatefulWidget {
  const VibeOthersScreen({
    super.key,
    required this.roomId,
    required this.channel,
    required this.musicChannel,
  });

  final String roomId;
  final WebSocketChannel channel;
  final WebSocketChannel musicChannel;

  @override
  State<VibeOthersScreen> createState() => _VibeOthersScreenState();
}

class _VibeOthersScreenState extends State<VibeOthersScreen> {
  final TextEditingController _sendMessageController = TextEditingController();
  // late final Future<void> _setMusicSource;

  @override
  void initState() {
    // _setMusicSource = context.read<MusicStreamerProvider>().setMusicSource();
    widget.channel.stream.listen((event) {
      if (!mounted) {
        return;
      }
      context.read<ChatsProvider>().updateChats(
        ChatModel(message: event, isReceived: true),
      );
    });
    // listening to music streamer
    // widget.musicChannel.stream.listen((event) {
    //   if (!mounted) {
    //     return;
    //   }
    //   context.read<MusicStreamerProvider>().updateMusicFromStream(event);
    // });
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
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.arrow_back_rounded),
                        ),
                      ),
                      Icon(
                        Icons.music_note_sharp,
                        size: 100,
                        color: Color(0xff00C699),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 22.0, bottom: 36.0),
                        child: Image.asset("assets/logos/logo.png", height: 40),
                      ),
                      Text("😎", style: TextStyle(fontSize: 40)),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Room Code: ",
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xffA04F51),
                              ),
                            ),
                            TextSpan(
                              text: widget.roomId,
                              style: TextStyle(
                                color: Color(0xff00C699),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          "Share Room Code To Others To Join👆🔝",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 22.0, 16.0, 22.0),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: ElevatedButton(
                            onPressed: () async {
                              try {
                                FilePickerResult? result =
                                    await FilePicker.platform.pickFiles();

                                if (result != null) {
                                  File musicFile = File(
                                    result.files.single.path!,
                                  );
                                  // get music file metadata
                                  AudioMetadata metadata = readMetadata(
                                    musicFile,
                                    getImage: false,
                                  );
                                  Map<String, String> requestBody = {
                                    "title": metadata.title ?? "N/A",
                                    "duration_seconds":
                                        metadata.duration?.inSeconds
                                            .toString() ??
                                        "0",
                                    "artist":
                                        metadata.artist ?? "Unknown Artist",
                                    "room_id": widget.roomId,
                                  };

                                  // upload to music room
                                  await RoomsService.uploadMusicToRoom(
                                    requestBody,
                                    musicFile,
                                  );
                                }
                                // showing successful snackbar
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Center(
                                      child: Text(
                                        "Musicc Successfully Uploaded",
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(8.0),
                                    elevation: 20,
                                    shape: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12),
                                      ),
                                    ),
                                    duration: const Duration(seconds: 3),
                                    behavior: SnackBarBehavior.floating,
                                    margin: EdgeInsets.only(
                                      bottom:
                                          MediaQuery.of(context).size.height *
                                          0.95,
                                      right:
                                          MediaQuery.of(context).size.width *
                                          0.35,
                                      left:
                                          MediaQuery.of(context).size.width *
                                          0.35,
                                    ),
                                  ),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Center(
                                      child: Text(
                                        e.toString(),
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(8.0),
                                    elevation: 20,
                                    shape: const OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12),
                                      ),
                                    ),
                                    duration: const Duration(seconds: 3),
                                    behavior: SnackBarBehavior.floating,
                                    margin: EdgeInsets.only(
                                      bottom:
                                          MediaQuery.of(context).size.height *
                                          0.95,
                                      right:
                                          MediaQuery.of(context).size.width *
                                          0.35,
                                      left:
                                          MediaQuery.of(context).size.width *
                                          0.35,
                                    ),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff00C699),
                              fixedSize: Size(180, 45),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(Icons.add, color: Colors.black),
                                Text(
                                  "Add A Track",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Consumer<MusicStreamerProvider>(
                        builder:
                            (context, value, child) =>
                                value.musicBytes.isEmpty
                                    ? Column(
                                      children: [
                                        Text("Start Listening On Stream"),
                                        IconButton(
                                          onPressed: () {
                                            // listening to music streamer
                                            widget.musicChannel.stream.listen((
                                              event,
                                            ) async {
                                              if (!context.mounted) {
                                                return;
                                              }
                                              await context
                                                  .read<MusicStreamerProvider>()
                                                  .updateMusicFromStream(event);
                                            }, onDone: () => print("Done"));

                                            // listening to music player
                                            // setting an oncomplete listener
                                            value.audioPlayer.onPlayerComplete.listen((
                                              event,
                                            ) async {
                                              // first check current music bytes and last music bytes set
                                              // then load more if there exists more
                                              if (value.musicBytes.length <=
                                                  value.lastMusicBytesSize) {
                                                print(
                                                  "No more music to stream",
                                                );
                                                return;
                                              }
                                              // last played seconds before new set
                                              int secs = value.lastSeconds;

                                              // first release resources to save memory
                                              await value.audioPlayer.release();

                                              // set music source again
                                              await value.setMusicSource();
                                              // seek to last play
                                              await value.audioPlayer.seek(
                                                Duration(seconds: secs),
                                              );
                                              await value.audioPlayer.resume();
                                            });
                                          },
                                          icon: Icon(Icons.play_arrow),
                                        ),
                                      ],
                                    )
                                    : SizedBox(
                                      child: IconButton(
                                        onPressed: () async {
                                          await value.setMusicSource();
                                          await value.audioPlayer.resume();
                                        },
                                        icon: Icon(Icons.play_arrow),
                                      ),
                                    ),
                      ),
                    ],
                  ),
                ),
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
