import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:music/utils/auto_player_task.dart';
import 'package:music/utils/json_manager.dart';
import 'package:music/utils/utils.dart';
import 'package:toast/toast.dart';

// import 'exmaple.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // List<Personalized> personalized;
  List<PlayList> dissList;
  PlayerModel model = PlayerModel();
  List<PlayList> qqList;
  // UserDetail model.userDetail;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    // SqlUtils().open('model.userDetail');
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      model = Store.value<PlayerModel>(context, listen: true);
      model.userDetail = await JsonManager.getUserInfo();
      Future.microtask(() async {
        if (model.userDetail == null) {
          alertInfo();
        } else {
          setState(() {
            model.qq = model.userDetail.creator.uin.toString();
          });
        }
      });
      Utils.checkVersions(context);
    });
  }

  alertInfo() {
    SureUserInfo.show(context, (text) async {
      if (text != null) await model.saveUserInfo(text, context);
      // Navigator.of(context)
      //     .push(MaterialPageRoute(builder: (_) => MainScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    JUTheme().init(context);
    ScreenUtil.init(context);
    // Store.value<PlayerModel>(context, listen: false).init();
    // Store.value<PlayerModel>(context, listen: false).init(context);
    return WillPopScope(
      child: JsScaffold(
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
                    alertInfo();
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
                  // AudioService.play();
                  Navigator.of(context).push(FadeRoute(page: SearchSongs()));
                },
              ),
            ),
          ),
        ),
        drawer: UserInfo(
          key: Key(model?.userDetail != null
              ? model.userDetail.creator.uin.toString()
              : 'none'),
          user: model.userDetail,
          init: alertInfo,
        ),
        body: SafeArea(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
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
      ),
      onWillPop: () {
        // 点击返回键的操作
        if (lastPopTime == null ||
            DateTime.now().difference(lastPopTime) > Duration(seconds: 2)) {
          lastPopTime = DateTime.now();
          Toast.show("再按一次退出", context);
        } else {
          lastPopTime = DateTime.now();
          // 退出app
          SystemNavigator.pop();
        }
      },
    );
  }

  var lastPopTime;
}
