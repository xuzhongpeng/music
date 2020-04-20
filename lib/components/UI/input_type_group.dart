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

class InputTypeGroup {
  static final blackTextStyle = TextStyle(
      color: JUTheme().theme.textTheme.body1.color,
      fontSize: 17,
      fontWeight: FontWeight.normal);
//单行
  static Widget customTextField1(
      {Decoration decoration,
      Color backGroundColor,
      FocusNode node,
      bool autofocus,
      TextStyle textStyle,
      Function(String) textFieldDidChanged,
      EdgeInsets margin,
      String placeHold,
      VoidCallback onTap,
      List<TextInputFormatter> inputFormatters,
      double width,
      double height,
      TextAlign textAlian,
      int maxLines,
      InputDecoration textDecoration,
      Function(String) onSubmitted,
      TextEditingController controller,
      TextInputAction textInputAction,
      TextInputType keyboardType,
      bool enable}) {
    return Container(
      width: width,
      height: height ?? 30,
      margin: margin ?? EdgeInsets.fromLTRB(0, 5, 0, 5),
      alignment: Alignment.center,
      decoration: (decoration ??
          BoxDecoration(
            color: backGroundColor ?? Color.fromRGBO(239, 239, 244, 1),
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
          )),
      child: TextField(
        focusNode: node,
        enabled: enable ?? true,
        keyboardType: keyboardType ?? TextInputType.text,
        controller: controller,
        onTap: onTap ?? null,
        textAlign: textAlian ?? TextAlign.left,
        autofocus: autofocus ?? false,
        textInputAction: textInputAction ?? null,
        onSubmitted: onSubmitted ?? null,
        maxLines: maxLines ?? 1,
        style: textStyle ?? blackTextStyle,
        inputFormatters: inputFormatters,
        decoration: textDecoration ??
            InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                border: InputBorder.none,
                hintText: placeHold ?? '请输入'),
        onChanged: textFieldDidChanged,
      ),
    );
  }

  static Widget customTextField(
      {Decoration decoration,
      Color backGroundColor,
      FocusNode node,
      bool autofocus,
      TextStyle textStyle,
      Function(String) textFieldDidChanged,
      EdgeInsets margin,
      String placeHold,
      VoidCallback onTap,
      List<TextInputFormatter> inputFormatters,
      double width,
      double height,
      TextAlign textAlian,
      int maxLines,
      InputDecoration textDecoration,
      Function(String) onSubmitted,
      TextEditingController controller,
      TextInputAction textInputAction,
      TextInputType keyboardType,
      bool enable}) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: <Widget>[
        InnerShadowWidget(
          color: Colors.grey[400],
          offset: Offset(1, 1),
          blur: 5,
          child: Container(
            width: width,
            height: (height ?? 30),
            margin: margin ?? EdgeInsets.fromLTRB(0, 0, 0, 0),
            // padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
            // alignment: Alignment.center,
            decoration: decoration ??
                BoxDecoration(
                  color: backGroundColor ?? Color.fromRGBO(244, 245, 246, 1),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: <Widget>[
                controller == null || controller?.text == ''
                    ? Container(
                        width: width,
                        alignment: textAlian == TextAlign.center
                            ? Alignment.center
                            : Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 3),
                        child: Text(
                          placeHold ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 17, color: Colors.grey),
                        ))
                    : Container(),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 5),
          width: width,
          child: TextField(
            onTap: onTap ?? null,
            textAlignVertical: TextAlignVertical.center,
            focusNode: node,
            enabled: enable ?? true,
            keyboardAppearance: Brightness.light,
            keyboardType: TextInputType.text,
            controller: controller,
            textAlign: textAlian ?? TextAlign.left,
            autofocus: autofocus ?? false,
            textInputAction: textInputAction ?? null,
            onSubmitted: onSubmitted ?? null,
            minLines: 1,
            maxLines: maxLines ?? 1,
            style: textStyle ?? blackTextStyle,
            inputFormatters: inputFormatters,
            decoration: textDecoration ??
                InputDecoration(
                  // prefixIcon: prefix,
                  // fillColor:
                  //     backGroundColor ?? Color.fromRGBO(239, 239, 244, 1),
                  // contentPadding: EdgeInsets.only(left: 5, top: 0),
                  border: InputBorder.none,
                ),
            onChanged: textFieldDidChanged,
          ),
        ),
      ],
    );
  }
}
