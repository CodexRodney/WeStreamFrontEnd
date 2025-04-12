import 'package:flutter/material.dart';
import 'package:westreamfrontend/constants/custom_icons.dart';
import 'package:westreamfrontend/models/music_model.dart';
import 'package:westreamfrontend/screens/vibe_alone/widgets/widgets.dart';
import 'package:westreamfrontend/utils/fetch_music.dart';

class VibeAloneScreen extends StatefulWidget {
  const VibeAloneScreen({super.key});

  @override
  State<VibeAloneScreen> createState() => _VibeAloneScreenState();
}

class _VibeAloneScreenState extends State<VibeAloneScreen> {
  late Future<List<MusicModel>?> _fetchMusic;

  @override
  void initState() {
    _fetchMusic = FetchMusic().fetchmusic();
    super.initState();
  }

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
                FutureBuilder(
                  future: _fetchMusic,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: ListView.builder(
                          itemBuilder:
                              (context, index) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: MusicContainer(
                                  musicIndex: index + 1,
                                  artist:
                                      snapshot.data![index].artist ??
                                      "Unknown Artist",
                                  musicName:
                                      snapshot.data![index].title ?? "N/A",
                                ),
                              ),
                          itemCount: snapshot.data!.length,
                        ),
                      );
                    } else if (snapshot.hasData && snapshot.data == null) {
                      // TODO replace with lotti files
                      return Text("No Music Found");
                    } else if (snapshot.hasError) {
                      // TODO replace with lotti files
                      return Text(snapshot.error.toString());
                    }
                    // TODO replace with lotti files
                    return CircularProgressIndicator();
                  },
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
                PlayerController(
                  songLength: Duration(minutes: 3, seconds: 36).inSeconds,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
