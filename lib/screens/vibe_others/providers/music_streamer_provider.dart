import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:westreamfrontend/screens/vibe_others/models/music_model.dart';
// import 'package:just_audio/just_audio.dart';

class MusicStreamerProvider with ChangeNotifier {
  AudioPlayer audioPlayer = AudioPlayer();
  List<int> musicBytes = [];
  // holds last seconds before player was set source
  int lastSeconds = 0;
  // holds the value of the last bytes that was used to set music source
  int lastMusicBytesSize = 0;
  bool isFirstTime = true;
  List<MusicModel> musicsAdded = [];
  List<TableRow> musicTableRow = [
    TableRow(
      children: [
        Text(
          "Track",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Text(
          "Artist",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Text(
          "Added By",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ],
    ),
  ];

  Future<void> setMusicSource() async {
    if (musicBytes.isEmpty) return;
    await audioPlayer.setSource(BytesSource(Uint8List.fromList(musicBytes)));
    // set last seconds after setting player source will used later to help in seeking
    Duration? lastSecDur = await audioPlayer.getDuration();
    print("Last Seconds duration before getting seconds Is $lastSecDur");
    lastSeconds = lastSecDur?.inSeconds ?? 0;
    print("Last Seconds were: $lastSeconds");
    // set last music bytes
    lastMusicBytesSize = musicBytes.length;
    print("Last Music length was $lastMusicBytesSize");
  }

  Future<void> updateMusicFromStream(event) async {
    // await setMusicSource();
    musicBytes.addAll(event);
    if (isFirstTime) {
      // await setMusicSource();
      isFirstTime = false;
      print("First");
      // notifyListeners();
    }

    // // if (isFirstTime) {}
    notifyListeners();
  }

  void updateAddedMusics(Map<String, dynamic> json) {
    musicsAdded.add(MusicModel.fromJson(json));
    musicTableRow.add(
      TableRow(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 100,
                height: 50,
                color: Colors.red,
                child: Center(
                  child: Text(
                    json["title"][0],
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Text(json["title"], style: TextStyle(fontSize: 16)),
            ],
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Text(json["artist"], style: TextStyle(fontSize: 16)),
          ),
          TableCell(
            verticalAlignment: TableCellVerticalAlignment.middle,
            child: Text(json["addedBy"], style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
    notifyListeners();
  }
}
