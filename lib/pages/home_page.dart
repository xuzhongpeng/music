import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music/components/UI/app_bar.dart';
import 'package:music/components/UI/circle_image.dart';
import 'package:music/components/UI/horizontal_song_list.dart';
import 'package:music/components/UI/input_type_group.dart';
import 'package:music/components/UI/js_scaffold.dart';
import 'package:music/components/UI/page_route.dart';
import 'package:music/components/UI/sure_user_info.dart';
import 'package:music/components/color/theme.dart';
import 'package:music/components/drawer/user_info.dart';
import 'package:music/components/neumorphism/shadow.dart';
import 'package:music/entities/playlist.dart';
import 'package:music/entities/q/user_detail.dart';
import 'package:music/pages/lyric_page.dart';
import 'package:music/pages/play_list_detail.dart';
import 'package:music/pages/search_songs.dart';
import 'package:music/provider/player_model.dart';
import 'package:music/services/q/songs_service.dart';
import 'package:music/stores/store.dart';
import 'package:music/entities/classification.dart';
import 'package:music/utils/json_manager.dart';
// import 'package:music/utils/sql_utils.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // List<Personalized> personalized;
  List<PlayList> dissList;
  PlayerModel get model => Store.value<PlayerModel>(context, listen: false);
  List<PlayList> qqList;
  // UserDetail model.userDetail;
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    // SqlUtils().open('model.userDetail');
    model.userDetail = await JsonManager.getUserInfo();
    Future.microtask(() async {
      if (model.userDetail == null) {
        SureUserInfo.show(context, () async {
          model.saveUserInfo();
          setState(() {});
        });
      } else {
        setState(() {
          model.qq = model.userDetail.creator.uin.toString();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    JUTheme().init(context);
    ScreenUtil.init(context);
    // Store.value<PlayerModel>(context, listen: false).init();
    // Store.value<PlayerModel>(context, listen: false).init(context);
    return JsScaffold(
      // backgroundColor: Colors.grey[200],
      appBar: GMAppBar(
        title: "JSSHOU的音乐盒",
        leading: Builder(
          builder: (context) => Container(
            padding: EdgeInsets.only(left: 10),
            child: IconButton(
              icon: OutShadow(
                padding: EdgeInsets.all(8),
                radius: 5,
                child: Icon(
                  Icons.menu,
                  size: 18,
                  color: Theme.of(context).primaryIconTheme.color,
                ),
              ),
              onPressed: () {
                // Navigator.of(context).push(FadeRoute(page: LyricPage()));
                if (model.userDetail != null) {
                  Scaffold.of(context).openDrawer();
                } else {
                  SureUserInfo.show(context, (text) async {
                    model.qq = text;
                    model.userDetail =
                        await SongService().getQSongListByQQ(qq: model.qq);
                    await JsonManager.saveUser(model.userDetail.toJson());
                    setState(() {});
                  });
                }
              },
            ),
          ),
        ),
        trailing: Builder(
          builder: (context) => Container(
            padding: EdgeInsets.only(right: 10),
            child: IconButton(
              icon: OutShadow(
                padding: EdgeInsets.all(8),
                radius: 5,
                child: Icon(
                  Icons.search,
                  color: Theme.of(context).primaryIconTheme.color,
                  size: 18,
                ),
              ),
              onPressed: () {
                Navigator.of(context).push(FadeRoute(page: SearchSongs()));
              },
            ),
          ),
        ),
      ),
      drawer: UserInfo(
        user: model.userDetail,
        init: init,
      ),
      body: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 10),
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
          ),
        ]),
      ),
    );
  }
}
