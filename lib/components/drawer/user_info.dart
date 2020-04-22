import 'package:flutter/material.dart';
import 'package:music/components/UI/circle_image.dart';
import 'package:music/components/UI/page_route.dart';
import 'package:music/components/UI/sure_user_info.dart';
import 'package:music/components/neumorphism/insertShadow.dart';
import 'package:music/components/neumorphism/shadow.dart';
import 'package:music/entities/playlist.dart';
import 'package:music/entities/q/user_detail.dart';
import 'package:music/pages/play_list_detail.dart';
import 'package:music/provider/player_model.dart';
import 'package:music/stores/store.dart';

import '../modal_alert.dart';

class UserInfo extends StatelessWidget {
  final UserDetail user;
  final VoidCallback init;
  UserInfo({Key key, this.user, this.init}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    PlayerModel model = Store.value<PlayerModel>(context, listen: false);
    return Drawer(
        child: Container(
            color: Theme.of(context).backgroundColor,
            child: user != null
                ? ListView(
                    children: <Widget>[
                      UserAccountsDrawerHeader(
                        decoration: BoxDecoration(
                            color: Theme.of(context).backgroundColor),
                        accountEmail: Text(
                          user.creator.uinWeb + ('(更换)'),
                          style: Theme.of(context).textTheme.body2,
                        ),
                        accountName: Text(user.creator.nick,
                            style: Theme.of(context).textTheme.body1),
                        onDetailsPressed: () {
                          init();
                        },
                        currentAccountPicture: OutShadow(
                          radius: 25,
                          child: CircleImage(child: user.creator.headpic),
                        ),
                      ),
                      _divider(),
                      ListTile(
                        title: Text(
                          '关于软件',
                          style: Theme.of(context).textTheme.body1,
                        ),
                        onTap: () {
                          Modal.show(
                            context,
                            child: EnterUserInfo(),
                          );
                        },
                      ),
                      _divider(),
                      ListTile(
                        title: Text(
                          '收藏',
                          style: Theme.of(context).textTheme.body1,
                        ),
                        subtitle: Text(model.love.length.toString() + "首歌曲",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.body2),
                        leading: OutShadow(
                          radius: 25,
                          child: CircleImage(
                            child: user.creator.headpic,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).push(FadeRoute(
                              page: PlayListDetail(
                                  songList: model.love,
                                  play: PlayList(
                                      name: "收藏",
                                      picUrl: user.creator.headpic))));
                        },
                      ),
                      _divider(),
                      //分割线
                      ...user.mymusic
                          .map(
                            (music) => ListTile(
                              title: Text(
                                music.title,
                                style: Theme.of(context).textTheme.body1,
                              ),
                              subtitle: Text(music.subtitle,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.body2),
                              leading: OutShadow(
                                radius: 25,
                                child: CircleImage(
                                  child: music.laypic,
                                ),
                              ),
                              onTap: () {
                                Navigator.of(context).push(FadeRoute(
                                    page: PlayListDetail(
                                        play: PlayList(
                                            id: music.id,
                                            name: music.title,
                                            picUrl: music.laypic))));
                              },
                            ),
                          )
                          .toList(),
                      _divider(), //分割线
                      ...user.mydiss.list
                          .map((music) => Column(children: [
                                ListTile(
                                  title: Text(
                                    music.title,
                                    style: Theme.of(context).textTheme.body1,
                                  ),
                                  subtitle: Text(music.subtitle,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.body2),
                                  leading: OutShadow(
                                    radius: 25,
                                    child: CircleImage(
                                      child: music.picurl,
                                    ),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).push(FadeRoute(
                                        page: PlayListDetail(
                                            play: PlayList(
                                                id: music.dissid.toString(),
                                                name: music.title,
                                                picUrl: music.picurl))));
                                  },
                                ),
                                _divider()
                              ]))
                          .toList(),
                    ],
                  )
                : Container(
                    width: 100,
                    height: 100,
                    alignment: Alignment.center,
                    color: Colors.transparent,
                    child: GestureDetector(
                      child: Text('登录'),
                    ))));
  }

  _divider() {
    return Container(
      height: 4,
      child: InnerShadowWidget(
        color: Colors.white,
        offset: Offset(-1, -1),
        blur: 1,
        child: InnerShadowWidget(
          color: Colors.grey[400],
          offset: Offset(-1, 1),
          blur: 1,
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(241, 242, 246, 1),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, Colors.white],
                tileMode: TileMode.clamp,
              ),
              borderRadius: BorderRadius.all(Radius.circular(1)),
            ),
          ),
        ),
      ),
    );
  }
}

//关于软件
class EnterUserInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        color: Colors.black26,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () {},
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 320,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20),
                  alignment: Alignment.centerLeft,
                  child: Column(children: <Widget>[
                    Text(
                      '关于软件',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          decoration: TextDecoration.none),
                    ),
                    Text(
                      'about Soft',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          decoration: TextDecoration.none),
                    ),
                  ]),
                ),
                Container(
                    child: OutShadow(
                  width: 250,
                  padding: EdgeInsets.all(10),
                  child: Text(
                    '此软件为JSShou编写,\n有问题请进入我的博客(jsshou.cn)留言,\n学习交流请加我QQ号1452754335,\n此软件只做学习交流，不做任何商业用途！',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        decoration: TextDecoration.none),
                  ),
                )),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: OutShadow(
                        width: 60,
                        height: 40,
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            '确定',
                            style: TextStyle(
                                color: Colors.black,
                                decoration: TextDecoration.none,
                                fontSize: 15),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
