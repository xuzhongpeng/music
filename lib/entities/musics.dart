import 'from_type.dart';

class Musics {
  String name;
  String singer;
  Song url;
  FromType from;
  String id;
  String cid;
  String medie; //咪咕用
  List<String> imagUrls;

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
