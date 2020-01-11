import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music/components/UI/app_bar.dart';
import 'package:music/components/UI/circle_image.dart';
import 'package:music/components/UI/horizontal_song_list.dart';
import 'package:music/components/UI/input_type_group.dart';
import 'package:music/components/UI/js_scaffold.dart';
import 'package:music/components/UI/page_route.dart';
import 'package:music/entities/playlist.dart';
import 'package:music/entities/q/user_detail.dart';
import 'package:music/pages/lyric_page.dart';
import 'package:music/pages/play_list_detail.dart';
import 'package:music/pages/search_songs.dart';
import 'package:music/provider/player_model.dart';
import 'package:music/services/q/songs_service.dart';
import 'package:music/stores/store.dart';
import 'package:music/entities/classification.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // List<Personalized> personalized;
  List<PlayList> dissList;
  List<PlayList> qqList;
  UserDetail user;
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    user = await SongService().getQSongListByQQ(qq: "1452754335");
    ScreenUtil.init(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // Store.value<PlayerModel>(context, listen: false).init();
    // Store.value<PlayerModel>(context, listen: false).init(context);
    double imgWidth = 100;
    return JsScaffold(
      appBar: GMAppBar(
        title: 'Home',
        leading: Builder(
          builder: (context) => Container(
            padding: EdgeInsets.only(left: 10),
            child: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Navigator.of(context).push(FadeRoute(page: LyricPage()));
                // Scaffold.of(context).openDrawer();
              },
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: user != null
            ? ListView(
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountEmail: Text(user.creator.uinWeb),
                    accountName: Text(user.creator.nick),
                    onDetailsPressed: () {},
                    currentAccountPicture:
                        CircleImage(child: user.creator.headpic),
                  ),
                  ...user.mymusic
                      .map(
                        (music) => ListTile(
                          title: Text(music.title),
                          subtitle: Text(
                            music.subtitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          leading: CircleImage(
                            child: music.laypic,
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
                          leading: CircleImage(
                            child: music.picurl,
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
      ),
      body: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
            alignment: Alignment.center,
            width: size.width,
            // padding: EdgeInsets.symmetric(horizontal: 10),
            child: Hero(
              tag: 'search',
              child: Material(
                child: InputTypeGroup.customTextField(
                    textAlian: TextAlign.center,
                    width: size.width * 0.95,
                    placeHold: "搜索",
                    onTap: () {
                      Navigator.of(context)
                          .push(FadeRoute(page: SearchSongs()));
                    }),
              ),
            ),
          ),
          Expanded(
            child: ListView(
                children: classification
                    .map((list) => HorizontalSongList(
                          type: list,
                          callBack: (play, heroKey) {
                            Navigator.of(context).push(FadeRoute(
                                page: PlayListDetail(
                                    play: play, heroKey: heroKey)));
                          },
                        ))
                    .toList()),
          ),
        ]),
      ),
    );
  }
}
