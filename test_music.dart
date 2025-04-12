import 'package:westreamfrontend/utils/fetch_music.dart';

void main() async {
  FetchMusic fetcher = FetchMusic();
  var musics = await fetcher.fetchmusic();
  print(musics?.length);
}
