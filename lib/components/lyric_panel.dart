import 'package:flutter/material.dart';
import 'package:music/entities/lyric.dart';
import 'package:music/provider/player_model.dart';
import 'package:music/stores/store.dart';

typedef void PositionChangeHandler(int second);

class LyricPanel extends StatefulWidget {
  final Lyric lyric;

  LyricPanel(@required this.lyric);

  @override
  State<StatefulWidget> createState() {
    return new LyricState();
  }
}

class LyricState extends State<LyricPanel> {
  int index = 0;
  LyricSlice currentSlice;
  PositionChangeHandler handler;
  @override
  void initState() {
    super.initState();
    // handler = ((position) {
    //   // print("..handler" + position.toString());

    // });
  }

  void change() {
    if (widget.lyric != null) {
      try {
        var _player = Store.value<PlayerModel>(context, listen: false);
        if (_player.position.inSeconds < 3) {
          index = 0;
        }
        LyricSlice slice = widget.lyric.slices[index];
        if (_player.position.inSeconds > slice.startTime) {
          index++;
          setState(() {
            currentSlice = slice;
          });
        }
      } catch (e) {
        print(e);
        index = 0;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    change();
    return new Container(
      child: new Center(
        child: new Container(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Column(
              children: <Widget>[
                Text(
                  widget.lyric.slices.length > index
                      ? widget.lyric.slices[index - 2].slice
                      : "",
                  style: new TextStyle(
                    color: Colors.white,
                  ),
                ),
                Text(
                  currentSlice != null ? currentSlice.slice : "",
                  style: new TextStyle(color: Colors.white, fontSize: 20),
                ),
                Text(
                  widget.lyric.slices.length > index
                      ? widget.lyric.slices[index].slice
                      : "",
                  style: new TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            )),
      ),
    );
  }

  List<Widget> buildLyricItems(Lyric lyric) {
    List<Widget> items = new List();
    for (LyricSlice slice in lyric.slices) {
      if (slice != null && slice.slice != null) {
        items.add(new Center(
          child: new Container(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Text(
              slice.slice,
              style: new TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ));
      }
    }
    return items;
  }
}
