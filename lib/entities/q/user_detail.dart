class UserDetail {
  Creator creator;
  String mymusictype;
  List<Mymusic> mymusic;
  Mydiss mydiss;

  UserDetail({this.creator, this.mymusictype, this.mymusic, this.mydiss});

  UserDetail.fromJson(Map<String, dynamic> json) {
    creator =
        json['creator'] != null ? new Creator.fromJson(json['creator']) : null;
    mymusictype = json['mymusictype'];
    if (json['mymusic'] != null) {
      mymusic = new List<Mymusic>();
      json['mymusic'].forEach((v) {
        mymusic.add(new Mymusic.fromJson(v));
      });
    }
    mydiss =
        json['mydiss'] != null ? new Mydiss.fromJson(json['mydiss']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.creator != null) {
      data['creator'] = this.creator.toJson();
    }
    data['mymusictype'] = this.mymusictype;
    if (this.mymusic != null) {
      data['mymusic'] = this.mymusic.map((v) => v.toJson()).toList();
    }
    if (this.mydiss != null) {
      data['mydiss'] = this.mydiss.toJson();
    }
    return data;
  }
}

class Creator {
  String nick;
  String headpic;
  String ifpic;
  int uin;
  String uinWeb;
  String encryptUin;
  int isfollow;
  int islock;
  String jumpkey;
  Backpic backpic;
  Nums nums;

  Creator(
      {this.nick,
      this.headpic,
      this.ifpic,
      this.uin,
      this.uinWeb,
      this.encryptUin,
      this.isfollow,
      this.islock,
      this.jumpkey,
      this.backpic,
      this.nums});

  Creator.fromJson(Map<String, dynamic> json) {
    nick = json['nick'];
    headpic = json['headpic'];
    ifpic = json['ifpic'];
    uin = json['uin'];
    uinWeb = json['uin_web'];
    encryptUin = json['encrypt_uin'];
    isfollow = json['isfollow'];
    islock = json['islock'];
    jumpkey = json['jumpkey'];
    backpic =
        json['backpic'] != null ? new Backpic.fromJson(json['backpic']) : null;
    nums = json['nums'] != null ? new Nums.fromJson(json['nums']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nick'] = this.nick;
    data['headpic'] = this.headpic;
    data['ifpic'] = this.ifpic;
    data['uin'] = this.uin;
    data['uin_web'] = this.uinWeb;
    data['encrypt_uin'] = this.encryptUin;
    data['isfollow'] = this.isfollow;
    data['islock'] = this.islock;
    data['jumpkey'] = this.jumpkey;
    if (this.backpic != null) {
      data['backpic'] = this.backpic.toJson();
    }
    if (this.nums != null) {
      data['nums'] = this.nums.toJson();
    }
    return data;
  }
}

class Backpic {
  String picurl;
  int type;
  String title;

  Backpic({this.picurl, this.type, this.title});

  Backpic.fromJson(Map<String, dynamic> json) {
    picurl = json['picurl'];
    type = json['type'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['picurl'] = this.picurl;
    data['type'] = this.type;
    data['title'] = this.title;
    return data;
  }
}

class Nums {
  int visitornum;
  int fansnum;
  int follownum;
  int followusernum;
  int followsingernum;
  int frdnum;

  Nums(
      {this.visitornum,
      this.fansnum,
      this.follownum,
      this.followusernum,
      this.followsingernum,
      this.frdnum});

  Nums.fromJson(Map<String, dynamic> json) {
    visitornum = json['visitornum'];
    fansnum = json['fansnum'];
    follownum = json['follownum'];
    followusernum = json['followusernum'];
    followsingernum = json['followsingernum'];
    frdnum = json['frdnum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['visitornum'] = this.visitornum;
    data['fansnum'] = this.fansnum;
    data['follownum'] = this.follownum;
    data['followusernum'] = this.followusernum;
    data['followsingernum'] = this.followsingernum;
    data['frdnum'] = this.frdnum;
    return data;
  }
}

class Mymusic {
  String title;
  String picurl;
  String laypic;
  String subtitle;
  String jumpurl;
  int jumptype;
  String jumpkey;
  String id;
  MusicBykey musicBykey;
  int type;
  int num0;
  int num1;
  int num2;

  Mymusic(
      {this.title,
      this.picurl,
      this.laypic,
      this.subtitle,
      this.jumpurl,
      this.jumptype,
      this.jumpkey,
      this.id,
      this.musicBykey,
      this.type,
      this.num0,
      this.num1,
      this.num2});

  Mymusic.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    picurl = json['picurl'];
    laypic = json['laypic'];
    subtitle = json['subtitle'];
    jumpurl = json['jumpurl'];
    jumptype = json['jumptype'];
    jumpkey = json['jumpkey'];
    id = json['id'];
    musicBykey = json['music_bykey'] != null
        ? new MusicBykey.fromJson(json['music_bykey'])
        : null;
    type = json['type'];
    num0 = json['num0'];
    num1 = json['num1'];
    num2 = json['num2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['picurl'] = this.picurl;
    data['laypic'] = this.laypic;
    data['subtitle'] = this.subtitle;
    data['jumpurl'] = this.jumpurl;
    data['jumptype'] = this.jumptype;
    data['jumpkey'] = this.jumpkey;
    data['id'] = this.id;
    if (this.musicBykey != null) {
      data['music_bykey'] = this.musicBykey.toJson();
    }
    data['type'] = this.type;
    data['num0'] = this.num0;
    data['num1'] = this.num1;
    data['num2'] = this.num2;
    return data;
  }
}

class MusicBykey {
  String urlKey;
  String urlParams;

  MusicBykey({this.urlKey, this.urlParams});

  MusicBykey.fromJson(Map<String, dynamic> json) {
    urlKey = json['url_key'];
    urlParams = json['url_params'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url_key'] = this.urlKey;
    data['url_params'] = this.urlParams;
    return data;
  }
}

class Mydiss {
  int num;
  String title;
  String laypic;
  String jumpurl;
  List<Playlist> list;

  Mydiss({this.num, this.title, this.laypic, this.jumpurl, this.list});

  Mydiss.fromJson(Map<String, dynamic> json) {
    num = json['num'];
    title = json['title'];
    laypic = json['laypic'];
    jumpurl = json['jumpurl'];
    if (json['list'] != null) {
      list = new List<Playlist>();
      json['list'].forEach((v) {
        list.add(new Playlist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['num'] = this.num;
    data['title'] = this.title;
    data['laypic'] = this.laypic;
    data['jumpurl'] = this.jumpurl;
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Playlist {
  int dissid;
  int dirid;
  String picurl;
  String title;
  String subtitle;
  int icontype;
  String iconurl;
  int isshow;
  int dirShow;

  Playlist(
      {this.dissid,
      this.dirid,
      this.picurl,
      this.title,
      this.subtitle,
      this.icontype,
      this.iconurl,
      this.isshow,
      this.dirShow});

  Playlist.fromJson(Map<String, dynamic> json) {
    dissid = json['dissid'];
    dirid = json['dirid'];
    picurl = json['picurl'];
    title = json['title'];
    subtitle = json['subtitle'];
    icontype = json['icontype'];
    iconurl = json['iconurl'];
    isshow = json['isshow'];
    dirShow = json['dir_show'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dissid'] = this.dissid;
    data['dirid'] = this.dirid;
    data['picurl'] = this.picurl;
    data['title'] = this.title;
    data['subtitle'] = this.subtitle;
    data['icontype'] = this.icontype;
    data['iconurl'] = this.iconurl;
    data['isshow'] = this.isshow;
    data['dir_show'] = this.dirShow;
    return data;
  }
}
