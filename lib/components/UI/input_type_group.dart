/*
 * @Author: xuzhongpeng
 * @email: xuzhongpeng@foxmail.com
 * @Date: 2019-11-12 15:55:37
 * @LastEditors  : xuzhongpeng
 * @LastEditTime : 2019-12-29 21:02:37
 * @Description: 输入组件封装
 */
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music/components/color/theme.dart';
import 'package:music/components/neumorphism/insertShadow.dart';

class InputTypeGroup extends StatefulWidget {
  final Decoration decoration;
  Color backGroundColor;
  final FocusNode node;
  bool autofocus;
  final TextStyle textStyle;
  final Function(String) textFieldDidChanged;
  final EdgeInsets margin;
  final String placeHold;
  final VoidCallback onTap;
  final List<TextInputFormatter> inputFormatters;
  final double width;
  final double height;
  final TextAlign textAlian;
  final int maxLines;
  final InputDecoration textDecoration;
  final Function(String) onSubmitted;
  TextEditingController controller;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final bool enable;
  InputTypeGroup(
      {this.decoration,
      this.backGroundColor,
      this.node,
      this.autofocus = false,
      this.textStyle,
      this.textFieldDidChanged,
      this.margin,
      this.placeHold,
      this.onTap,
      this.inputFormatters,
      this.width,
      this.height = 34,
      this.textAlian,
      this.maxLines,
      this.textDecoration,
      this.onSubmitted,
      this.controller,
      this.textInputAction,
      this.keyboardType,
      this.enable});
  @override
  _StateInputTypeGroup createState() => _StateInputTypeGroup();
}

class _StateInputTypeGroup extends State<InputTypeGroup> {
  static final blackTextStyle = TextStyle(
      color: JUTheme().theme.textTheme.bodyText1.color,
      fontSize: 17,
      fontWeight: FontWeight.normal);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.controller == null) {
      widget.controller = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: <Widget>[
          InnerShadowWidget(
            color: Colors.white,
            offset: Offset(-1, -1),
            blur: 1,
            child: InnerShadowWidget(
              color: Colors.grey[400],
              offset: Offset(1, 1),
              blur: 1,
              child: Container(
                width: widget.width,
                height: (widget.height ?? 30),
                margin: widget.margin ?? EdgeInsets.fromLTRB(0, 0, 0, 0),
                // padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
                // alignment: Alignment.center,
                decoration: widget.decoration ??
                    BoxDecoration(
                      color: widget.backGroundColor ??
                          Color.fromRGBO(244, 245, 246, 1),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: <Widget>[
                    widget.controller == null || widget.controller?.text == ''
                        ? Container(
                            width: widget.width,
                            alignment: widget.textAlian == TextAlign.center
                                ? Alignment.center
                                : Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 7),
                            child: Text(
                              widget.placeHold ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 17, color: Colors.grey[300]),
                            ))
                        : Container(),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 5),
            width: widget.width,
            child: TextField(
                onTap: widget.onTap ?? null,
                textAlignVertical: TextAlignVertical.center,
                focusNode: widget.node,
                enabled: widget.enable ?? true,
                keyboardAppearance: Brightness.light,
                keyboardType: widget.keyboardType ?? TextInputType.text,
                controller: widget.controller,
                textAlign: widget.textAlian ?? TextAlign.left,
                autofocus: widget.autofocus ?? false,
                textInputAction: widget.textInputAction ?? null,
                onSubmitted: widget.onSubmitted ?? null,
                minLines: 1,
                maxLines: widget.maxLines ?? 1,
                style: widget.textStyle ?? blackTextStyle,
                inputFormatters: widget.inputFormatters,
                decoration: widget.textDecoration ??
                    InputDecoration(
                      // prefixIcon: prefix,
                      // fillColor:
                      //     backGroundColor ?? Color.fromRGBO(239, 239, 244, 1),
                      // contentPadding: EdgeInsets.only(left: 5, top: 0),
                      border: InputBorder.none,
                    ),
                onChanged: (text) {
                  if (text != '') setState(() {});
                  widget.textFieldDidChanged?.call(text);
                }),
          ),
        ],
      ),
    );
  }
}
