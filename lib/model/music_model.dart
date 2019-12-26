import 'package:music/entities/musics.dart';
import 'package:music/services/songs_service.dart';
import 'package:music/stores/provider.dart';

class MusicModel extends MuProvider {
  List<Musics> musics = List(); // 播放列表
  Musics play; //当前播放

  Future<List<Musics>> search(String key) {
    return SongService().searchQQ(key);
  }

  Future<String> getDetail(Musics musics) async {
    return await SongService().getDetail(musics);
  }
}
