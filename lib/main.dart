import 'package:flutter/material.dart';
import 'package:music/config/http.dart';
import 'package:music/model/player_model.dart';
import 'package:music/pages/home_page.dart';
import 'package:music/stores/store.dart';

import 'model/music_model.dart';

void main() {
  Http http = Http();
  http.init();
  return runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  DateTime lastPopTime;
  @override
  Widget build(BuildContext context) {
    return Store.provider(
      providers: [
        ChangeNotifierProvider<PlayerModel>(create: (_) => PlayerModel()),
        ChangeNotifierProvider<MusicModel>(create: (_) => MusicModel())
      ],
      child:
          // WillPopScope(child:
          new MaterialApp(
        theme: new ThemeData(
            // primarySwatch: Colors.blue,
            fontFamily: 'alifont',
            primaryColor: Colors.white),
        home: new HomePage(),
      ),
      // onWillPop: () {
      //   // 点击返回键的操作
      //   if (lastPopTime == null ||
      //       DateTime.now().difference(lastPopTime) > Duration(seconds: 2)) {
      //     lastPopTime = DateTime.now();
      //     print("再按一次");
      //   } else {
      //     lastPopTime = DateTime.now();
      //     // 退出app
      //     SystemNavigator.pop();
      //   }
      // },
      // ),
    );
  }
}
