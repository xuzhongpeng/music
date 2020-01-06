List<MusicType> classification = [
  MusicType(name: "全部", id: 10000000),
  MusicType(name: "流行", id: 6),
  MusicType(name: "民谣", id: 28),
  MusicType(name: "经典", id: 136),
  MusicType(name: "网络歌曲", id: 146),
  MusicType(name: "中国风", id: 145),
  MusicType(name: "情歌", id: 148),
  MusicType(name: "安静", id: 122),
];

class MusicType {
  String name;
  int id;
  MusicType({this.name, this.id});
}
