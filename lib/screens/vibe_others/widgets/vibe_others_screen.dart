import 'dart:convert';
import 'dart:io';

import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:westreamfrontend/screens/start_screen/services/room_services.dart';
import 'package:westreamfrontend/screens/vibe_others/models/chat_model.dart';
import 'package:westreamfrontend/screens/vibe_others/models/viber_model.dart';
import 'package:westreamfrontend/screens/vibe_others/providers/chats_provider.dart';
import 'package:westreamfrontend/screens/vibe_others/providers/music_streamer_provider.dart';
import 'package:westreamfrontend/screens/vibe_others/providers/viber_provider.dart';
import 'package:westreamfrontend/screens/vibe_others/widgets/chat_widget.dart';
import 'package:westreamfrontend/screens/vibe_others/widgets/user_presentation.dart';

class VibeOthersScreen extends StatefulWidget {
  const VibeOthersScreen({
    super.key,
    required this.roomId,
    required this.viberId,
    required this.channel,
    required this.musicChannel,
    required this.eventChannel,
    required this.isAdmin,
    required this.username,
  });

  final String roomId;
  final String viberId;
  final String username;
  final WebSocketChannel channel;
  final WebSocketChannel musicChannel;
  final WebSocketChannel eventChannel;
  final bool isAdmin;

  @override
  State<VibeOthersScreen> createState() => _VibeOthersScreenState();
}

class _VibeOthersScreenState extends State<VibeOthersScreen> {
  final TextEditingController _sendMessageController = TextEditingController();
  ValueNotifier<Widget> adminWidgetNotifier = ValueNotifier<Widget>(
    SizedBox.shrink(),
  );
  // late final Future<void> _setMusicSource;

  @override
  void initState() {
    super.initState();
    // _setMusicSource = context.read<MusicStreamerProvider>().setMusicSource();
    widget.channel.stream.listen((event) {
      if (!mounted) {
        return;
      }
      context.read<ChatsProvider>().updateChats(
        ChatModel(message: event, isReceived: true),
      );
    });

    // start listening on music streamer upon entering
    widget.musicChannel.stream.listen((event) {
      if (!mounted) {
        return;
      }
      context.read<MusicStreamerProvider>().updateMusicFromStream(event);
    });

    // communicate to others about joining, if not admin
    // admin doesn't communicate since they are first to join
    if (!widget.isAdmin) widget.eventChannel.sink.add("joining");

    // start listening on music streamer upon entering
    widget.eventChannel.stream.listen((event) {
      if (!mounted) {
        return;
      }
      Map<String, dynamic> message = jsonDecode(event);
      for (String key in message.keys) {
        // adding only one viber
        if (key.compareTo("viber_join") == 0) {
          ViberModel viber = ViberModel.fromJson(message[key]);
          if (viber.isAdmin) {
            // updating admin side
            adminWidgetNotifier.value = Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Admin"),
                UserPresentationWidget(username: viber.username),
              ],
            );
          } else {
            context.read<VibersProvider>().updateVibers(viber);
          }
        }
        if (key.compareTo("vibers") == 0) {
          for (var v in message[key]) {
            ViberModel viber = ViberModel.fromJson(v);
            if (viber.isAdmin) {
              // updating admin side
              adminWidgetNotifier.value = Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Admin"),
                  UserPresentationWidget(username: viber.username),
                ],
              );
            } else {
              context.read<VibersProvider>().updateVibers(viber);
            }
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
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
                      TextButton(
                        onPressed: () async {
                          await Clipboard.setData(
                            ClipboardData(text: widget.roomId),
                          );
                        },
                        child: RichText(
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
                                    ? widget.isAdmin
                                        ? Column(
                                          children: [
                                            Text("Start Listening On Stream"),
                                            IconButton(
                                              onPressed: () {
                                                print("Pressed");
                                                // send message to start music stream
                                                widget.musicChannel.sink.add(
                                                  "play",
                                                );
                                                print("message sent");
                                                // listening to music player
                                                // setting an oncomplete listener
                                                value.audioPlayer.onPlayerComplete.listen((
                                                  event,
                                                ) async {
                                                  // first check current music bytes and last music bytes set
                                                  // then load more if there exists more
                                                  if (value.musicBytes.length <=
                                                      value
                                                          .lastMusicBytesSize) {
                                                    print(
                                                      "No more music to stream",
                                                    );
                                                    return;
                                                  }
                                                  // last played seconds before new set
                                                  int secs = value.lastSeconds;

                                                  // first release resources to save memory
                                                  await value.audioPlayer
                                                      .release();

                                                  if (!mounted) return;
                                                  // set music source again
                                                  await value.setMusicSource();

                                                  if (!mounted) return;
                                                  // seek to last play
                                                  await value.audioPlayer.seek(
                                                    Duration(seconds: secs),
                                                  );

                                                  if (!mounted) return;
                                                  await value.audioPlayer
                                                      .resume();
                                                });
                                              },
                                              icon: Icon(Icons.play_arrow),
                                            ),
                                          ],
                                        )
                                        : Text("Enjoy Stream")
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
                      const Spacer(),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.13,
                        color: Color(0xffE9EEB3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            widget.isAdmin
                                ? Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Admin"),
                                    UserPresentationWidget(
                                      username: widget.username,
                                    ),
                                  ],
                                )
                                : ValueListenableBuilder(
                                  valueListenable: adminWidgetNotifier,
                                  builder:
                                      (context, value, child) =>
                                          adminWidgetNotifier.value,
                                ),
                            Column(
                              children: [
                                Text("Others"),
                                Row(
                                  children: [
                                    !widget.isAdmin
                                        ? UserPresentationWidget(
                                          username: widget.username,
                                        )
                                        : SizedBox.shrink(),
                                    SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.25,
                                      height:
                                          MediaQuery.of(context).size.height *
                                          0.1,
                                      child: Consumer<VibersProvider>(
                                        builder:
                                            (
                                              context,
                                              value,
                                              child,
                                            ) => ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder:
                                                  (context, index) =>
                                                      UserPresentationWidget(
                                                        username:
                                                            value
                                                                .vibers[index]
                                                                .username,
                                                      ),
                                              itemCount: value.vibers.length,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
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
