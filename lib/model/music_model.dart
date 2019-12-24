import 'package:audioplayers/audioplayers.dart';
import 'package:music/entities/musics.dart';
import 'package:music/services/songs_service.dart';
import 'package:music/stores/provider.dart';

class MusicModel extends MuProvider {
  AudioPlayer audioPlayer = AudioPlayer();
  List<Musics> musics = List();
  search(String key) {
    SongService().searchQQ(key).then((song) {
      musics = song;
      notifyListeners();
    });
  }

  Future<String> getDetail(Musics musics) async {
    return await SongService().getDetail(musics);
  }
}
