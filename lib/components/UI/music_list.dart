import 'package:flutter/material.dart';
import 'package:music/components/iconfont/iconfont.dart';
import 'package:music/entities/musics.dart';

class MusicList extends StatelessWidget {
  final Musics song;
  MusicList({this.song});
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: 60,
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  width: 1, color: Color.fromRGBO(222, 226, 230, 1)))),
      child: Row(
        children: <Widget>[
          Container(
            width: size.width * 0.7,
            padding: EdgeInsets.only(left: 10),
            // color: Colors.red,
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  height: 30,
                  child: Text(song.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: Color.fromRGBO(0, 0, 0, 1),
                          fontSize: 16,
                          fontWeight: FontWeight.w300)),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  height: 20,
                  child: Text(song.singer,
                      style: TextStyle(
                          color: Color.fromRGBO(119, 119, 119, 1),
                          fontSize: 12)),
                )
              ],
            ),
          ),
          Container(
            width: size.width * 0.3,
            // color: Colors.blue,
            padding: EdgeInsets.only(right: 15),
            alignment: Alignment.centerRight,
            child: Icon(
              IconFont.iconbofang,
              color: Color.fromRGBO(119, 119, 119, 1),
            ),
          )
        ],
      ),
    );
  }
}
