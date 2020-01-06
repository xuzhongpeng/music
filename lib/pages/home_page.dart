import 'package:flutter/material.dart';
import 'package:music/components/UI/app_bar.dart';
import 'package:music/components/UI/horizontal_song_list.dart';
import 'package:music/components/UI/input_type_group.dart';
import 'package:music/components/UI/js_scaffold.dart';
import 'package:music/components/UI/music_bottom_bar.dart';
import 'package:music/components/UI/page_route.dart';
import 'package:music/components/drawer/music_list.dart';
import 'package:music/entities/personalized.dart';
import 'package:music/entities/playlist.dart';
import 'package:music/entities/q/diss_list.dart';
import 'package:music/entities/q/user_detail.dart';
import 'package:music/model/music_model.dart';
import 'package:music/pages/play_list_detail.dart';
import 'package:music/pages/search_songs.dart';
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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // Store.value<PlayerModel>(context, listen: false).init();
    // Store.value<PlayerModel>(context, listen: false).init(context);
    return JsScaffold(
      appBar: GMAppBar(
        title: 'Home',
        leading: Container(
          padding: EdgeInsets.only(left: 10),
          child: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {},
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
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: AssetImage('images/ab.jpg'),
                    ),
                  ),
                  ListTile(
                    title: Text('ListTile1'),
                    subtitle: Text(
                      'ListSubtitle1',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    leading: CircleAvatar(child: Text("1")),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  Divider(), //分割线
                  ListTile(
                    title: Text('ListTile2'),
                    subtitle: Text(
                      'ListSubtitle2',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    leading: CircleAvatar(child: Text("2")),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  Divider(), //分割线
                  ListTile(
                    title: Text('ListTile3'),
                    subtitle: Text(
                      'ListSubtitle3',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    leading: CircleAvatar(child: Text("3")),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  Divider(), //分割线
                  new AboutListTile(
                    icon: new CircleAvatar(child: new Text("4")),
                    child: new Text("AboutListTile"),
                    applicationName: "AppName",
                    applicationVersion: "1.0.1",
                    applicationIcon: new Image.asset(
                      'images/bb.jpg',
                      width: 55.0,
                      height: 55.0,
                    ),
                    applicationLegalese: "applicationLegalese",
                    aboutBoxChildren: <Widget>[
                      new Text("第一条..."),
                      new Text("第二条...")
                    ],
                  ),
                  Divider(), //分割线
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
