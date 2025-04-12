import 'package:audioplayers/audioplayers.dart';
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
  late Future<List<MusicModel>?> _musicList;
  late final AudioPlayer _player;
  int _selectedSongPos = 0;
  final FetchMusic _musicInst = FetchMusic();

  @override
  void initState() {
    _player = AudioPlayer();
    _musicList = _musicInst.fetchmusic();
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
    await _player.release();
    await _player.dispose();
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
                  future: _musicList,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: ListView.builder(
                          itemBuilder:
                              (context, index) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextButton(
                                  onPressed: () async {
                                    // stoping files with blank plays
                                    if (snapshot.data![index].musicFile?.path ==
                                        null) {
                                      return;
                                    }
                                    // releases resources before changing song
                                    await _player.release();
                                    await _player.setSource(
                                      DeviceFileSource(
                                        snapshot.data![index].musicFile!.path,
                                      ),
                                    );
                                    setState(() {
                                      _selectedSongPos = index;
                                    });
                                  },
                                  style: TextButton.styleFrom(
                                    shape: LinearBorder(),
                                  ),
                                  child: MusicContainer(
                                    musicIndex: index + 1,
                                    artist:
                                        snapshot.data![index].artist ??
                                        "Unknown Artist",
                                    musicName:
                                        snapshot.data![index].title ?? "N/A",
                                    textcolor: Colors.black,
                                  ),
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
                // TODO handle posibility of music not being loaded after decoupling playing instance
                FutureBuilder(
                  future: _musicList,
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      return PlayerController(
                        player: _player,
                        musicLength:
                            _musicInst.musics[_selectedSongPos].musicSeconds ??
                            0,
                        musicPath:
                            _musicInst
                                .musics[_selectedSongPos]
                                .musicFile
                                ?.path ??
                            "",
                      );
                    }
                    if (snapshot.hasData && snapshot.data == null) {
                      return Center(child: Text("No Music Loaded"));
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                    }
                    return Center(child: Text("Loading Music"));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
