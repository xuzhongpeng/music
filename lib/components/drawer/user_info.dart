import 'package:flutter/material.dart';
import 'package:music/components/UI/circle_image.dart';
import 'package:music/components/UI/page_route.dart';
import 'package:music/components/UI/sure_user_info.dart';
import 'package:music/components/neumorphism/shadow.dart';
import 'package:music/entities/playlist.dart';
import 'package:music/entities/q/user_detail.dart';
import 'package:music/pages/play_list_detail.dart';
import 'package:music/provider/player_model.dart';
import 'package:music/stores/store.dart';

class UserInfo extends StatelessWidget {
  final UserDetail user;
  final VoidCallback init;
  UserInfo({this.user, this.init});
  @override
  Widget build(BuildContext context) {
    PlayerModel model = Store.value<PlayerModel>(context, listen: false);
    return Drawer(
      child: user != null
          ? ListView(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountEmail: Text(
                    user.creator.uinWeb,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.body2.color),
                  ),
                  accountName: Text(user.creator.nick),
                  onDetailsPressed: () {
                    SureUserInfo.show(context, (text) {
                      model.qq = text;
                      init();
                    });
                  },
                  currentAccountPicture: OutShadow(
                    radius: 25,
                    child: CircleImage(child: user.creator.headpic),
                  ),
                ),
                ListTile(
                  title: Text('收藏'),
                  subtitle: Text(
                    model.love.length.toString() + "首歌曲",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
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
                                name: "收藏", picUrl: user.creator.headpic))));
                  },
                ),
                Divider(), //分割线
                ...user.mymusic
                    .map(
                      (music) => ListTile(
                        title: Text(music.title),
                        subtitle: Text(
                          music.subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
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
                Divider(), //分割线
                ...user.mydiss.list
                    .map(
                      (music) => ListTile(
                        title: Text(music.title),
                        subtitle: Text(
                          music.subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
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
                    )
                    .toList(),
              ],
            )
          : Container(),
    );
  }
}
