import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music/entities/personalized.dart';

class HorizontalSongList extends StatelessWidget {
  final List<Personalized> personalized;
  HorizontalSongList({this.personalized});
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
                    (p) => Container(
                      padding: EdgeInsets.all(0),
                      width: width,
                      child: Column(
                        children: <Widget>[
                          new Container(
                            height: width - 10, //设置高度
                            width: width - 10,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(14),
                              child: Image.network(
                                p.picUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            width: width - 30,
                            child: Text(
                              p.name,
                              style: TextStyle(fontSize: 10),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ),
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
