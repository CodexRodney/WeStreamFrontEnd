// used to collect music files from a set directory
import 'dart:io';

import 'package:audio_metadata_reader/audio_metadata_reader.dart';
import 'package:westreamfrontend/models/music_model.dart';

class FetchMusic {
  String path =
      "/home/rodney/Projects/personal_projects/westreamfrontend/assets/test_music";
  late Directory musicDir;
  List<MusicModel> musics = [];

  FetchMusic([String? path]) {
    musicDir = Directory(path ?? this.path);
  }

  Future<List<MusicModel>?> fetchmusic() async {
    if (!await musicDir.exists()) {
      throw Exception("Music Set Directory Doesn't Exist");
    }
    List<FileSystemEntity> files =
        await musicDir
            .list(recursive: true, followLinks: true)
            .where((event) => event is File)
            .where((event) => event.path.contains("mp3"))
            .toList();

    // iterate through the files
    for (FileSystemEntity file in files) {
      AudioMetadata metadata = readMetadata(file as File, getImage: false);
      musics.add(
        MusicModel(
          artist: metadata.artist,
          title: metadata.title,
          musicFile: metadata.file,
          musicSeconds: metadata.duration?.inSeconds,
        ),
      );
    }
    return musics.isEmpty ? null : musics;
  }
}
