import 'package:flutter/material.dart';
import 'package:music/components/UI/app_bar.dart';
import 'package:music/components/UI/js_scaffold.dart';
import 'package:music/components/UI/music_bottom_bar.dart';
import 'package:music/components/UI/music_list.dart';
import 'package:music/components/iconfont/iconfont.dart';
import 'package:music/entities/musics.dart';
import 'package:music/entities/playlist.dart';
import 'package:music/provider/player_model.dart';
import 'package:music/services/q/songs_service.dart';
import 'package:music/stores/store.dart';

class PlayListDetail extends StatefulWidget {
  final PlayList play;
  final String heroKey;
  final List<MusicEntity> songList;
  PlayListDetail({this.play, this.heroKey, this.songList});
  @override
  _PlayListDetailState createState() => _PlayListDetailState();
}

class _PlayListDetailState extends State<PlayListDetail> {
  List<MusicEntity> songList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.songList != null) {
      songList = widget.songList;
    } else {
      init();
    }
  }

  PlayerModel get _playModel => Store.value<PlayerModel>(context);
  init() async {
    songList = await SongService().getQSongs(id: widget.play.id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [
      SliverAppBar(
        backgroundColor: Colors.black26,
        title: Text(
          widget.play.name,
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 18,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.menu,
              color: Color.fromRGBO(1, 1, 1, 0),
            ),
            onPressed: () {},
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          )
        ],
        // floating: true,
        flexibleSpace: Stack(
          children: <Widget>[
            widget.heroKey != null
                ? Hero(
                    tag: widget.heroKey,
                    child: Material(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.red,
                        child: widget.play.picUrl != null &&
                                widget.play.picUrl != ''
                            ? Image.network(
                                widget.play.picUrl,
                                fit: BoxFit.cover,
                              )
                            : Container(),
                      ),
                    ),
                  )
                : Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.red,
                    child:
                        widget.play.picUrl != null && widget.play.picUrl != ''
                            ? Image.network(
                                widget.play.picUrl,
                                fit: BoxFit.cover,
                              )
                            : Container(),
                  ),
            Positioned(
              bottom: 5,
              right: 10,
              child: GestureDetector(
                onTap: () {
                  _playModel.addPlayerList(songList);
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        IconFont.iconbofang,
                        color: Colors.white,
                        size: 16,
                      ),
                      Text(
                        '播放全部',
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        expandedHeight: 200,
      )
    ];

    if (songList != null)
      widgetList.add(SliverList(
          delegate: SliverChildBuilderDelegate(
        (context, index) => GestureDetector(
          child: MusicItem(
            song: songList[index],
          ),
          onTap: () {
            //
            _playModel.playingMusic(songList[index]);
          },
        ),
        childCount: songList.length,
      )));
    return JsScaffold(
      body: CustomScrollView(
        slivers: widgetList,
      ),
    );
  }
}
