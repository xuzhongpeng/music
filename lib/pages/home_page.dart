import 'package:flutter/material.dart';
import 'package:music/components/UI/app_bar.dart';
import 'package:music/components/UI/horizontal_song_list.dart';
import 'package:music/components/UI/input_type_group.dart';
import 'package:music/components/UI/music_bottom_bar.dart';
import 'package:music/components/UI/page_route.dart';
import 'package:music/components/drawer/music_list.dart';
import 'package:music/entities/personalized.dart';
import 'package:music/entities/playlist.dart';
import 'package:music/entities/q/diss_list.dart';
import 'package:music/pages/play_list_detail.dart';
import 'package:music/pages/search_songs.dart';
import 'package:music/services/q/songs_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // List<Personalized> personalized;
  List<PlayList> dissList;
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    List list = await SongService().getQSongList();
    // personalized = list.map((m) => Personalized.fromJson(m)).toList();
    dissList = list.map((m) => DissList.fromJson(m)).toList();
    setState(() {});
  }

  GlobalKey<ScaffoldState> _globalKeyState = GlobalKey();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // Store.value<PlayerModel>(context, listen: false).init();
    // Store.value<PlayerModel>(context, listen: false).init(context);
    return Scaffold(
      key: _globalKeyState,
      endDrawer: MusicListDrawer(),
      appBar: GMAppBar(
        title: 'Home',
        leading: Container(
          padding: EdgeInsets.only(left: 10),
          child: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              _globalKeyState.currentState.openEndDrawer();
            },
          ),
        ),
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
            child: Column(
              children: <Widget>[
                HorizontalSongList(
                  personalized: dissList ?? [],
                  callBack: (play) {
                    Navigator.of(context)
                        .push(FadeRoute(page: PlayListDetail(play: play)));
                  },
                ),
              ],
            ),
          ),
        ]),
      ),
      bottomNavigationBar: MusicBottomBar(),
    );
  }
}
