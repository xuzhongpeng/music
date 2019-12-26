import 'from_type.dart';

class Musics {
  String name;
  String singer;
  Song url;
  FromType from;
  String id;
  String cid;
  String medie; //咪咕用
  String headerImg;

  Musics.fromMigu(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    cid = json['cid'];

    from = FromType.migu;
  }

  Musics.fromQQ(Map<String, dynamic> json) {
    name = json['songname'];
    singer =
        (json['singer'] as List).map((si) => si['name']).toList().join(',');
    id = json['songid'].toString();
    headerImg =
        'https://y.gtimg.cn/music/photo_new/T002R300x300M000${json['albummid']}.jpg';
    cid = json['songmid'];
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
}
