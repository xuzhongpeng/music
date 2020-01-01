/*
 * @Author: xuzhongpeng
 * @email: xuzhongpeng@foxmail.com
 * @Date: 2019-12-30 20:52:52
 * @LastEditors  : xuzhongpeng
 * @LastEditTime : 2020-01-01 16:01:23
 * @Description: 网易云音乐 推荐歌单
 */
class Personalized {
  int id;
  int type;
  String name;
  String copywriter;
  String picUrl;
  bool canDislike;
  int trackNumberUpdateTime;
  int playCount;
  int trackCount;
  bool highQuality;
  String alg;

  Personalized(
      {this.id,
      this.type,
      this.name,
      this.copywriter,
      this.picUrl,
      this.canDislike,
      this.trackNumberUpdateTime,
      this.playCount,
      this.trackCount,
      this.highQuality,
      this.alg});

  Personalized.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    name = json['name'];
    copywriter = json['copywriter'];
    picUrl = json['picUrl'];
    canDislike = json['canDislike'];
    trackNumberUpdateTime = json['trackNumberUpdateTime'];
    playCount = json['playCount'];
    trackCount = json['trackCount'];
    highQuality = json['highQuality'];
    alg = json['alg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    data['name'] = this.name;
    data['copywriter'] = this.copywriter;
    data['picUrl'] = this.picUrl;
    data['canDislike'] = this.canDislike;
    data['trackNumberUpdateTime'] = this.trackNumberUpdateTime;
    data['playCount'] = this.playCount;
    data['trackCount'] = this.trackCount;
    data['highQuality'] = this.highQuality;
    data['alg'] = this.alg;
    return data;
  }
}
