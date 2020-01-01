import 'package:flutter/material.dart';
import 'package:music/components/UI/app_bar.dart';
import 'package:music/components/UI/music_bottom_bar.dart';
import 'package:music/components/UI/music_list.dart';
import 'package:music/entities/musics.dart';
import 'package:music/entities/playlist.dart';
import 'package:music/model/player_model.dart';
import 'package:music/services/q/songs_service.dart';
import 'package:music/stores/store.dart';

class PlayListDetail extends StatefulWidget {
  final PlayList play;
  PlayListDetail({this.play});
  @override
  _PlayListDetailState createState() => _PlayListDetailState();
}

class _PlayListDetailState extends State<PlayListDetail> {
  List<MusicEntity> songList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
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
        centerTitle: false,
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
        floating: false,
        flexibleSpace: Hero(
          tag: widget.play.picUrl,
          child: Material(
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.red,
              child: Image.network(
                widget.play.picUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
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
            _playModel.playingMusic(context, songList[index]);
          },
        ),
        childCount: songList.length,
      )));
    return Scaffold(
      body: CustomScrollView(
        slivers: widgetList,
      ),
      bottomNavigationBar: MusicBottomBar(),
    );
  }
}
