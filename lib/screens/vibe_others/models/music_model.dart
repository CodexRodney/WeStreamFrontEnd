class MusicModel {
  String title;
  String artist;
  String addedBy;
  int durationInSecs;

  MusicModel.fromJson(Map<String, dynamic> json)
    : title = json["title"],
      artist = json["artist"],
      addedBy = json["addedBy"],
      durationInSecs = json["durationInSecs"];
}
