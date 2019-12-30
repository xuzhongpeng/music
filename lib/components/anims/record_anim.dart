/*
 * @Author: xuzhongpeng
 * @email: xuzhongpeng@foxmail.com
 * @Date: 2019-12-24 08:43:14
 * @LastEditors  : xuzhongpeng
 * @LastEditTime : 2019-12-30 20:07:39
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
    double imgWidth = 250;
    return new Container(
      margin: new EdgeInsets.symmetric(vertical: 10.0),
      height: imgWidth,
      width: imgWidth,
      child: new RotationTransition(
          turns: animation,
          child: Store.connect<PlayerModel>(builder: (_, _playModel, __) {
            return Container(
              width: imgWidth,
              height: imgWidth,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 1),
                  borderRadius: BorderRadius.circular(imgWidth / 2)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(imgWidth / 2),
                child: Image.network(_playModel.play?.headerImg,
                    fit: BoxFit.cover),
              ),
            );
          })),
    );
  }
}
