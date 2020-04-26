import 'package:audio_service/audio_service.dart';

import 'from_type.dart';
import 'lyric.dart';

class MusicEntity {
  String name;
  String singer;
  Song url;
  FromType from;
  String id;
  String cid;
  Lyric lyric;
  String medie; //咪咕用
  String headerImg;

  MusicEntity.fromMigu(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    cid = json['cid'];

    from = FromType.migu;
  }

  MusicEntity.fromQQ(Map<String, dynamic> json) {
    name = json['songname'];
    singer =
        (json['singer'] as List).map((si) => si['name']).toList().join(',');
    id = json['songid'].toString();
    headerImg =
        'https://y.gtimg.cn/music/photo_new/T002R300x300M000${json['albummid']}.jpg';
    cid = json['songmid'];
  }

  MusicEntity.fromJson(Map json) {
    name = json['name'];
    singer = json['singer'];
    url = json['url'] != null ? Song.fromJson(json['url']) : null;
    id = json['id'];
    cid = json['cid'];
    medie = json['medie'];
    headerImg = json['headerImg'];
    if (json['from'] == FromType.qq.toString()) {
      from = FromType.qq;
    } else if (json['from'] == FromType.migu.toString()) {
      from = FromType.migu;
    } else {
      from = FromType.m163;
    }
    if (json['lyric'] != null) {
      lyric = Lyric.fromJson(json['lyric']);
    }
  }
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = Map();
    map['name'] = name;
    map['singer'] = singer;
    map['url'] = url?.toJson();
    map['id'] = id;
    map['cid'] = cid;
    map['medie'] = medie;
    map['headerImg'] = headerImg;
    map['from'] = from.toString();
    if (lyric != null) map['lyric'] = lyric.toJson();
    return map;
  }

  MediaItem toMediaItem() {
    return MediaItem(
        id: this.url.midUrl,
        album: '',
        title: this.name,
        artist: this.singer,
        artUri: this.headerImg);
  }
}

class Song {
  String pic;
  String bgPic;
  String minUrl;
  String midUrl;
  String bigUrl;

  Song.fromMigu(Map<String, dynamic> json) {
    pic = json['pic'];
    bgPic = json['bgPic'];
    minUrl = json['128k'];
    midUrl = json['320k'];
    bigUrl = json['flac'];
  }
  Song.fromQQ({this.pic, this.bgPic, this.minUrl})
      : this.midUrl = minUrl,
        this.bigUrl = minUrl;

  Song.fromJson(Map json) {
    pic = json['pic'];
    bgPic = json['bgPic'];
    minUrl = json['minUrl'];
    midUrl = json['midUrl'];
    bigUrl = json['bigUrl'];
  }
  toJson() {
    Map map = Map();
    map['pic'] = pic;
    map['bgPic'] = bgPic;
    map['minUrl'] = minUrl;
    map['midUrl'] = midUrl;
    map['bigUrl'] = bigUrl;
    return map;
  }
}
