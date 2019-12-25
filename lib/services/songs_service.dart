import 'package:dio/dio.dart';
import 'package:music/config/http.dart';
import 'package:music/entities/musics.dart';
import 'package:music/services/urls.dart';

class SongService {
  Future<List<Musics>> searchQQ(String keys) async {
    Response res = await Http().dio.get(
      "${Urls.qq}/search",
      queryParameters: {"key": keys},
    );
    if (res.data["result"] == 100) {
      List<Musics> musics = (res.data['data']['list'] as List).map((song) {
        return Musics.fromQQ(song);
      }).toList();
      return musics;
    }
    return null;
  }

  //获取歌曲详情
  Future<String> getDetail(Musics music) async {
    Response res = await Http().dio.get(
      "${Urls.qq}/song/urls",
      queryParameters: {"id": music.cid},
    );
    if (res != null && res.data != null) {
      if (res.data['result'] == 100) {
        return res.data['data'][music.cid];
      } else {
        //出错
      }
    } else {
      return null;
    }
  }
}
