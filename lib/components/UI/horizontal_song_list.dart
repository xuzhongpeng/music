import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music/entities/classification.dart';
import 'package:music/entities/playlist.dart';
import 'package:music/entities/q/diss_list.dart';
import 'package:music/services/q/songs_service.dart';
// import 'package:music/entities/personalized.dart';

typedef Function PlayListCallBack(PlayList list, String key);

class HorizontalSongList extends StatefulWidget {
  final MusicType type;
  final PlayListCallBack callBack;
  HorizontalSongList({this.type, this.callBack});

  @override
  _HorizontalSongListState createState() => _HorizontalSongListState();
}

class _HorizontalSongListState extends State<HorizontalSongList>
    with AutomaticKeepAliveClientMixin {
  List<PlayList> dissList;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    List list = await SongService().getQSongList(category: widget.type.id);
    // personalized = list.map((m) => Personalized.fromJson(m)).toList();
    dissList = list.map((m) => DissList.fromJson(m)).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    double width = 120;
    return Container(
      height: 200,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: 30,
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  widget.type.name,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
              Row(
                children: <Widget>[
                  // Text(
                  //   '更多',
                  //   style: TextStyle(fontSize: 10),
                  // ),
                  // Icon(
                  //   Icons.navigate_next,
                  //   size: 15,
                  // )
                ],
              )
            ],
          ),
          dissList != null
              ? Expanded(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: dissList.map((p) {
                      String heroKey = md5
                          .convert(utf8.encode(
                              DateTime.now().microsecondsSinceEpoch.toString()))
                          .toString();
                      return GestureDetector(
                        child: MusicItem(
                            width: width,
                            picUrl: p.picUrl,
                            name: p.name,
                            heroKey: heroKey),
                        onTap: () {
                          widget.callBack != null
                              ? widget.callBack(p, heroKey)
                              : null;
                        },
                      );
                    }).toList(),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class MusicItem extends StatelessWidget {
  final double width;
  // final Personalized p;
  final String picUrl;
  final String name;
  final String heroKey;
  MusicItem({this.width, this.picUrl, this.name, this.heroKey});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0),
      width: width,
      child: Column(
        children: <Widget>[
          new Container(
            height: width - 10, //设置高度
            width: width - 10,
            child: Hero(
              tag: heroKey,
              child: Material(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(
                    picUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            width: width - 30,
            child: Text(
              name,
              style: TextStyle(fontSize: 10),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }
}
