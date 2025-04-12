import 'dart:io';

class MusicModel {
  String? title;
  String? artist;
  int? musicSeconds;
  File? musicFile;

  MusicModel({this.title, this.artist, this.musicFile, this.musicSeconds});
}
