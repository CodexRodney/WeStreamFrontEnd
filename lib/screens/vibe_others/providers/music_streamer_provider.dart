import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
// import 'package:just_audio/just_audio.dart';

class MusicStreamerProvider with ChangeNotifier {
  AudioPlayer audioPlayer = AudioPlayer();
  List<int> musicBytes = [];
  // holds last seconds before player was set source
  int lastSeconds = 0;
  // holds the value of the last bytes that was used to set music source
  int lastMusicBytesSize = 0;
  bool isFirstTime = true;

  Future<void> setMusicSource() async {
    if (musicBytes.isEmpty) return;
    await audioPlayer.setSource(BytesSource(Uint8List.fromList(musicBytes)));
    // set last seconds after setting player source will used later to help in seeking
    Duration? lastSecDur = await audioPlayer.getDuration();
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
}

// class MyCustomSource extends StreamAudioSource {
//   final List<int> bytes;
//   MyCustomSource(this.bytes);

//   @override
//   Future<StreamAudioResponse> request([int? start, int? end]) async {
//     start ??= 0;
//     end ??= bytes.length;
//     return StreamAudioResponse(
//       sourceLength: bytes.length,
//       contentLength: end - start,
//       offset: start,
//       stream: Stream.value(bytes.sublist(start, end)),
//       contentType: 'audio/mpeg',
//     );
//   }
// }
