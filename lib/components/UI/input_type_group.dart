/*
 * @Author: xuzhongpeng
 * @email: xuzhongpeng@foxmail.com
 * @Date: 2019-11-12 15:55:37
 * @LastEditors  : xuzhongpeng
 * @LastEditTime : 2019-12-25 19:41:06
 * @Description: 输入组件封装
 */
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputTypeGroup {
  static const blackTextStyle = TextStyle(
      color: Color(0xFF333333), fontSize: 17, fontWeight: FontWeight.normal);
//单行
  static Widget customTextField(
      {Decoration decoration,
      Color backGroundColor,
      FocusNode node,
      bool autofocus,
      TextStyle textStyle,
      Function(String) textFieldDidChanged,
      EdgeInsets margin,
      String placeHold,
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
      margin: margin ?? EdgeInsets.fromLTRB(0, 5, 20, 5),
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
}
