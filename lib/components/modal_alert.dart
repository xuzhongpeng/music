import 'package:flutter/material.dart';

class Modal {
  static Future<void> show(BuildContext context,
      {Widget child, Color backGroundColor}) {
    return Navigator.of(context)
        .push(FadeRoute(
            opaque: false,
            barrierColor: backGroundColor ?? Colors.white30,
            builder: (_) => child))
        .then((onValue) => onValue);
  }
}

class FadeRoute extends PageRoute {
  FadeRoute({
    @required this.builder,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.opaque = true,
    this.barrierDismissible = false,
    this.barrierColor,
    this.barrierLabel,
    this.maintainState = true,
  });

  final WidgetBuilder builder;

  @override
  final Duration transitionDuration;

  @override
  final bool opaque;

  @override
  final bool barrierDismissible;

  @override
  final Color barrierColor;

  @override
  final String barrierLabel;

  @override
  final bool maintainState;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) =>
      builder(context);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // final PageTransitionsTheme theme = Theme.of(context).pageTransitionsTheme;
    // return theme.buildTransitions(
    //     this, context, animation, secondaryAnimation, child);
    var begin = Offset(0.0, 1.0);
    var end = Offset(0.0, 0.0);
    var tween = Tween(begin: begin, end: end);
    var offsetAnimation = animation.drive(tween);

    return SlideTransition(
      position: offsetAnimation,
      child: child,
    );
  }
}
