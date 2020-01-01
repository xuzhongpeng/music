import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music/entities/playlist.dart';
// import 'package:music/entities/personalized.dart';

typedef Function PlayListCallBack(PlayList list);

class HorizontalSongList extends StatelessWidget {
  final List<PlayList> personalized;
  final PlayListCallBack callBack;
  HorizontalSongList({this.personalized, this.callBack});
  @override
  Widget build(BuildContext context) {
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
                  '为你推荐',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
              Row(
                children: <Widget>[
                  Text(
                    '更多',
                    style: TextStyle(fontSize: 10),
                  ),
                  Icon(
                    Icons.navigate_next,
                    size: 15,
                  )
                ],
              )
            ],
          ),
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: personalized
                  .map(
                    (p) => GestureDetector(
                      child: MusicItem(
                          width: width, picUrl: p.picUrl, name: p.name),
                      onTap: () {
                        callBack != null ? callBack(p) : null;
                      },
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class MusicItem extends StatelessWidget {
  final double width;
  // final Personalized p;
  final String picUrl;
  final String name;
  MusicItem({this.width, this.picUrl, this.name});
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
              tag: picUrl,
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
