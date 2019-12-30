/*
 * @Author: xuzhongpeng
 * @email: xuzhongpeng@foxmail.com
 * @Date: 2019-12-24 08:43:14
 * @LastEditors  : xuzhongpeng
 * @LastEditTime : 2019-12-29 22:21:52
 * @Description: 播放器页面
 */
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:music/model/music_model.dart';
import 'package:music/model/player_model.dart';
import 'package:music/stores/store.dart';

class RotateRecord extends AnimatedWidget {
  RotateRecord({Key key, Animation<double> animation})
      : super(key: key, listenable: animation);

  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return new Container(
      margin: new EdgeInsets.symmetric(vertical: 10.0),
      height: 250.0,
      width: 250.0,
      child: new RotationTransition(
          turns: animation,
          child: Store.connect<PlayerModel>(builder: (_, model, __) {
            return new Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(model.play?.headerImg ??
                      "https://images-na.ssl-images-amazon.com/images/I/51inO4DBH0L._SS500.jpg"),
                ),
              ),
            );
          })),
    );
  }
}
