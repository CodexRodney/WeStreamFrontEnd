import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:westreamfrontend/screens/start_screen/services/room_services.dart';
import 'package:westreamfrontend/screens/start_screen/services/vibers_services.dart';
import 'package:westreamfrontend/screens/vibe_alone/views/vibe_alone_screen.dart';
import 'package:westreamfrontend/screens/vibe_others/widgets/vibe_others_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController roomCodeController = TextEditingController();
    TextEditingController usernameController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 641,
          height: 1117,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.music_note_sharp, size: 166, color: Color(0xff00C699)),
              Padding(
                padding: const EdgeInsets.only(top: 22.0, bottom: 36.0),
                child: Image.asset("assets/logos/logo.png"),
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 28.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: TextFormField(
                          controller: roomCodeController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter room code';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            label: Center(
                              child: Text(
                                "Room Code",
                                style: TextStyle(
                                  color: Color(0xffA04F51),
                                  fontSize: 22,
                                ),
                              ),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(22),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 28.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: TextFormField(
                          controller: usernameController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter username';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            label: Center(
                              child: Text(
                                "UserName",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xffA04F51),
                                  fontSize: 22,
                                ),
                              ),
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(22),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (!formKey.currentState!.validate()) return;
                          // get user id
                          var response = await VibersService.getViberId();
                          String viberId = response["viber_id"];

                          // join room, isAdmin false since user not creating room
                          WebSocketChannel roomChannel =
                              await RoomsService.joinRoom(
                                roomCodeController.text.trim(),
                                viberId,
                                false,
                              );

                          // join music stream
                          WebSocketChannel musicChannel =
                              await RoomsService.joinMusicRoomChannel(viberId);

                          if (!context.mounted) return;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => VibeOthersScreen(
                                    roomId: roomCodeController.text.trim(),
                                    channel: roomChannel,
                                    musicChannel: musicChannel,
                                  ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xffF00055),
                          fixedSize: Size(210, 59),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                        child: Text(
                          "Join",
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          // create room
                          var response = await RoomsService.createRoom();
                          String roomId = response["Id"];

                          // get user id
                          response = await VibersService.getViberId();
                          String viberId = response["viber_id"];

                          // join room, isAdmin is True since user is creating room
                          WebSocketChannel roomChannel =
                              await RoomsService.joinRoom(
                                roomId,
                                viberId,
                                true,
                              );

                          // join music stream
                          WebSocketChannel musicChannel =
                              await RoomsService.joinMusicRoomChannel(viberId);
                          if (!context.mounted) return;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => VibeOthersScreen(
                                    roomId: roomId,
                                    channel: roomChannel,
                                    musicChannel: musicChannel,
                                  ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff00C699),
                          fixedSize: Size(210, 59),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                        child: Text(
                          "Create Room",
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 22.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VibeAloneScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffA04F51),
                    fixedSize: Size(
                      MediaQuery.of(context).size.width * 0.34,
                      59,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                  child: Text(
                    "I Just Want To Vibe Alone",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
