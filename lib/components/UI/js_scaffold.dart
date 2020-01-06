import 'package:flutter/material.dart';
import 'package:music/components/drawer/music_list.dart';
import 'package:music/stores/store.dart';
import 'package:music/model/music_model.dart';

import 'music_bottom_bar.dart';

class JsScaffold extends StatefulWidget {
  final Widget body;
  final PreferredSizeWidget appBar;

  JsScaffold({this.body, this.appBar});

  @override
  _JsScaffoldState createState() => _JsScaffoldState();
}

class _JsScaffoldState extends State<JsScaffold> {
  MusicModel get model => Store.value<MusicModel>(context);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  GlobalKey<ScaffoldState> globalKeyState = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKeyState,
      endDrawer: MusicListDrawer(),
      bottomNavigationBar: MusicBottomBar(globalKeyState: globalKeyState),
      body: widget.body,
      appBar: widget.appBar,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    globalKeyState = null;
  }
}
