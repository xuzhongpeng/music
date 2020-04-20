import 'package:flutter/material.dart';

class SureUserInfo {
  static show(BuildContext context, callBack) {
    return showDialog(
        context: context,
        builder: (cxt) {
          String qq = "";
          return Container(
              color: Colors.blue,
              width: MediaQuery.of(context).size.width,
              child: Center(
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
              ));
        });
  }
}
// Center(
//                 child: Column(children: [
//                   Material(
//                     child: TextField(
//                       onChanged: (text) {
//                         qq = text;
//                       },
//                     ),
//                   ),
//                   RaisedButton(
//                     child: Text('确定'),
//                     onPressed: () {
//                       if (qq == '') qq = '1452754335';
//                       Navigator.of(context).pop();
//                       callBack(qq);
//                     },
//                   )
//                 ]),
//               )
