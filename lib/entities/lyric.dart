class Lyric {
  ///艺人名
  String ar;

  ///曲名
  String ti;

  ///专辑名
  String al;

  ///编者（指编辑LRC歌词的人）
  String by;

  ///偏移量
  double offset;

  ///歌词
  List<LyricSlice> slices;
  Lyric({this.ar, this.ti, this.al, this.by, this.offset, this.slices});
  Lyric.fromJson(Map<String, dynamic> json) {
    ar = json['ar'];
    ti = json['ti'];
    al = json['al'];
    by = json['by'];
    offset = json['offset'];
    if (json['slices'] != null) {
      slices = new List<LyricSlice>();
      json['slices'].forEach((v) {
        slices.add(new LyricSlice.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ar'] = this.ar;
    data['ti'] = this.ti;
    data['al'] = this.al;
    data['by'] = this.by;
    data['offset'] = this.offset;
    if (this.slices != null) {
      data['slices'] = this.slices.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class LyricSlice {
  int startTime; //歌词片段开始时间
  int endTime;
  String slice; //片段内容

  LyricSlice({int startTime, int endTime, String slice}) {
    this.startTime = startTime;
    this.endTime = endTime;
    this.slice = slice;
  }

  LyricSlice.fromJson(Map<String, dynamic> json) {
    startTime = json['startTime'];
    endTime = json['endTime'];
    slice = json['slice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['startTime'] = this.startTime;
    data['endTime'] = this.endTime;
    data['slice'] = this.slice;
    return data;
  }
}
