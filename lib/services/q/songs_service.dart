import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:music/config/http.dart';
import 'package:music/entities/musics.dart';
import 'package:music/entities/q/user_detail.dart';
import 'package:music/services/api/user_service.dart';
import 'package:music/services/urls.dart';

class SongService {
  Future<List<MusicEntity>> searchQQ(String keys) async {
    Response res = await Http().dio.get(
      "${Urls.qq}/search",
      queryParameters: {"key": keys},
    );
    if (res.data["result"] == 100) {
      List<MusicEntity> musics = (res.data['data']['list'] as List).map((song) {
        return MusicEntity.fromQQ(song);
      }).toList();
      return musics;
    }
    return null;
  }

  //获取歌曲详情
  Future<String> getDetail(MusicEntity music) async {
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

  //获取歌单（qq）
  Future<List> getQSongList({int category = 10000000}) async {
    Response res = await Http().dio.get('${Urls.qq}/songlist/list',
        queryParameters: {"num": 10, "category": category});
    if (res != null && res.data != null) {
      if (res.data['result'] == 100) {
        return res.data['data']['list'];
      } else {
        //出错
        throw FlutterError("获取歌单出错");
      }
    } else {
      return null;
    }
  }

//根据qq号获取歌单
  Future<UserDetail> getQSongListByQQ({String qq = ""}) async {
    Response res = await Http()
        .dio
        .get('${Urls.qq}/user/detail', queryParameters: {"id": qq});
    if (res != null && res.data != null) {
      if (res.data['result'] == 100) {
        UserDetail detail = UserDetail.fromJson(res.data['data']);
        try {
          UserService.getInfo(detail.creator);
        } catch (e) {}
        return detail;
      } else {
        //出错
        throw FlutterError("获取歌单出错，请检查QQ号是否输入正确");
      }
    } else {
      return null;
    }
  }

  //根据qq号获取用户信息
  Future<List> getUserInfo({String qq = ""}) async {
    Response res = await Http()
        .dio
        .get('${Urls.qq}/user/detail', queryParameters: {"id": qq});
    if (res != null && res.data != null) {
      if (res.data['result'] == 100) {
        return res.data['data']['list'];
      } else {
        //出错
        throw FlutterError("获取歌单出错");
      }
    } else {
      return null;
    }
  }

  //根据歌单获取歌曲（qq）
  Future<List<MusicEntity>> getQSongs({String id}) async {
    Response res = await Http()
        .dio
        .get('${Urls.qq}/songlist', queryParameters: {"id": id});
    if (res != null && res.data != null) {
      if (res.data['result'] == 100) {
        List<MusicEntity> musics =
            (res.data['data']['songlist'] as List).map((song) {
          return MusicEntity.fromQQ(song);
        }).toList();
        return musics;
      } else {
        //出错
        throw FlutterError("获取歌单出错");
      }
    } else {
      return null;
    }
  }

  //获取歌词
  Future<String> getLyric(String id) async {
    Response res = await Http()
        .dio
        .get('${Urls.qq}/lyric', queryParameters: {"songmid": id});
    if (res != null && res.data != null) {
      if (res.data['result'] == 100) {
        if (res.data['data']['lyric'] != null) {
          return res.data['data']['lyric'];
        } else {
          return null;
        }
      } else {
        //出错
        print("获取歌词出错");
        return null;
      }
    } else {
      return null;
    }
  }

  //获取歌单(网易云)
  Future<List> getSongList() async {
    Response res = await Http().dio.get(
          "${Urls.m123}/personalized",
        );
    if (res != null && res.data != null) {
      if (res.data['code'] == 200) {
        return res.data['result'];
      } else {
        //出错
        throw FlutterError("获取歌单出错");
      }
    } else {
      return null;
    }
  }
}
