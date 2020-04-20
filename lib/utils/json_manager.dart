import 'dart:convert';
import 'dart:io';

import 'package:music/entities/musics.dart';
import 'package:music/entities/q/user_detail.dart';
import 'package:path_provider/path_provider.dart';

class JsonManager {
  //播放列表json
  static String _playerList = "music/playerList.json";
  static String _user = "music/userInfo.json";
  //当前播放名
  static String _nowPlayer = "playing";
  //播放列表名
  static String _musicList = "musicData";

  //保存当前播放
  static savePlaying(MusicEntity music) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    print(dir);
    File _file = await File('$dir/$_playerList').create(recursive: true);
    String content = _file.readAsStringSync();
    Map json;
    try {
      json = jsonDecode(content);
    } catch (e) {
      json = Map();
    }
    json[_nowPlayer] = music.toJson();
    _file.writeAsStringSync(jsonEncode(json));
  }

  //保存播放列表
  static saveMusicList(Map<String, dynamic> map) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    File _file = await File('$dir/$_playerList').create(recursive: true);
    String content = _file.readAsStringSync();
    Map json;
    try {
      json = jsonDecode(content);
    } catch (e) {
      json = Map();
    }
    json[_musicList] = map;
    _file.writeAsStringSync(jsonEncode(json));
  }

  //获取当前播放
  static Future<String> getPlaying() async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    File _file = await File('$dir/$_playerList').create(recursive: true);
    String content = _file.readAsStringSync();
    Map json;
    try {
      json = jsonDecode(content);
    } catch (e) {
      json = Map();
    }
    if (json[_nowPlayer] != null) {
      return MusicEntity.fromJson(json[_nowPlayer]).id;
    }
    return null;
  }

  //获取播放列表
  static Future<Map<String, dynamic>> getMusicList() async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    File _file = await File('$dir/$_playerList').create(recursive: true);
    String content = _file.readAsStringSync();
    Map json;
    try {
      json = jsonDecode(content);
    } catch (e) {
      json = Map();
    }
    if (json[_musicList] != null && json[_musicList] is Map<String, dynamic>) {
      return json;
    }
    return {};
  }

  //保存用户信息(覆盖)
  static Future<void> saveUser(Map<String, dynamic> map) async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    File _file = await File('$dir/$_user').create(recursive: true);
    _file.writeAsStringSync(jsonEncode(map));
  }

  //获取用户信息
  static Future<UserDetail> getUserInfo() async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    File _file = await File('$dir/$_user').create(recursive: true);
    String content = _file.readAsStringSync();
    Map json;
    try {
      json = jsonDecode(content);
    } catch (e) {}
    if (json != null) {
      return UserDetail.fromJson(json);
    }
    return null;
  }
}
