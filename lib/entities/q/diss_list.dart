import 'package:music/entities/playlist.dart';

class DissList extends PlayList {
  String dissid;
  String createtime;
  String commitTime;
  String dissname;
  String imgurl;
  String introduction;
  int listennum;
  int score;
  int version;
  Creator creator;

  DissList(
      {this.dissid,
      this.createtime,
      this.commitTime,
      this.dissname,
      this.imgurl,
      this.introduction,
      this.listennum,
      this.score,
      this.version,
      this.creator});

  DissList.fromJson(Map<String, dynamic> json) {
    this.id = json['dissid'];
    this.name = json['dissname'];
    this.picUrl = json['imgurl'];
    dissid = json['dissid'];
    createtime = json['createtime'];
    commitTime = json['commit_time'];
    dissname = json['dissname'];
    imgurl = json['imgurl'];
    introduction = json['introduction'];
    listennum = json['listennum'];
    score = json['score'];
    version = json['version'];
    creator =
        json['creator'] != null ? new Creator.fromJson(json['creator']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dissid'] = this.dissid;
    data['createtime'] = this.createtime;
    data['commit_time'] = this.commitTime;
    data['dissname'] = this.dissname;
    data['imgurl'] = this.imgurl;
    data['introduction'] = this.introduction;
    data['listennum'] = this.listennum;
    data['score'] = this.score;
    data['version'] = this.version;
    if (this.creator != null) {
      data['creator'] = this.creator.toJson();
    }
    return data;
  }
}

class Creator {
  int type;
  int qq;
  String encryptUin;
  String name;
  int isVip;
  String avatarUrl;
  int followflag;

  Creator(
      {this.type,
      this.qq,
      this.encryptUin,
      this.name,
      this.isVip,
      this.avatarUrl,
      this.followflag});

  Creator.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    qq = json['qq'];
    encryptUin = json['encrypt_uin'];
    name = json['name'];
    isVip = json['isVip'];
    avatarUrl = json['avatarUrl'];
    followflag = json['followflag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['qq'] = this.qq;
    data['encrypt_uin'] = this.encryptUin;
    data['name'] = this.name;
    data['isVip'] = this.isVip;
    data['avatarUrl'] = this.avatarUrl;
    data['followflag'] = this.followflag;
    return data;
  }
}
