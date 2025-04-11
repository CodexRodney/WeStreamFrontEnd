import 'package:flutter/material.dart';
import 'package:westreamfrontend/constants/custom_icons.dart';

class VibeAloneScreen extends StatelessWidget {
  const VibeAloneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.25,
            child: Column(
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
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(CustomIcons.circumMusicNote, size: 80),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(CustomIcons.clock, size: 70),
                    ),
                  ],
                ),
                Center(
                  child: Column(
                    children: [
                      Text("TIME PLAYED", style: TextStyle(fontSize: 40)),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32.0),
                        child: Text(
                          "22:00:10",
                          style: TextStyle(fontSize: 36, color: Colors.grey),
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 24),
                          children: [
                            TextSpan(
                              text: "TOTAL TIME: ",
                              style: TextStyle(color: Colors.black),
                            ),
                            TextSpan(
                              text: "10:48:32",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(CustomIcons.shuffle),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(CustomIcons.stepBackward),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.pause_outlined),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(CustomIcons.skipForward),
                    ),
                    IconButton(onPressed: () {}, icon: Icon(CustomIcons.loop)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text("1:35"),
                    ),
                    Container(
                      color: Colors.green,
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text("4:01"),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(CustomIcons.speaker),
                    ),
                    Container(
                      color: Colors.green,
                      width: MediaQuery.of(context).size.width * 0.1,
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
