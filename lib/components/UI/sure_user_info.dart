import 'package:flutter/material.dart';

class SureUserInfo {
  static show(BuildContext context, callBack) {
    return showDialog(
        context: context,
        builder: (cxt) {
          String qq = "";
          return Center(
            child: Column(children: [
              Material(
                child: TextField(
                  onChanged: (text) {
                    qq = text;
                  },
                ),
              ),
              RaisedButton(
                child: Text('确定'),
                onPressed: () {
                  if (qq == '') qq = '1452754335';
                  Navigator.of(context).pop();
                  callBack(qq);
                },
              )
            ]),
          );
        });
  }
}
