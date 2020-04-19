import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

const double _kNavBarPersistentHeight = 50.0;

const gmBarTitleStyle =
    TextStyle(fontSize: 17.0, color: Colors.white, fontWeight: FontWeight.w500);

final gmBarGreyTitleStyle = TextStyle(
    fontSize: 17.0, color: Colors.grey[400], fontWeight: FontWeight.w500);

const iosBack = Icon(
  Icons.arrow_back_ios,
  color: Colors.white,
  size: 20.0,
);

class GMAppBar extends StatefulWidget implements PreferredSizeWidget {
  GMAppBar(
      {Key key,
      this.title,
      this.titleColor,
      this.backgroundColors,
      this.trailing,
      this.bottom,
      this.leading,
      bool automaticallyImplyLeading,
      double actionSize,
      this.statusStyle,
      this.child,
      double barHeight = _kNavBarPersistentHeight})
      : this.automaticallyImplyLeading = automaticallyImplyLeading ?? true,
        this.actionSize = actionSize ?? 20.0,
        this.barHeight = barHeight,
        preferredSize =
            Size.fromHeight(barHeight + (bottom?.preferredSize?.height ?? 0.0)),
        super(key: key);

  final bool automaticallyImplyLeading;
  final String title;
  final List<Color> backgroundColors;
  final Color titleColor;
  final double actionSize;
  final double barHeight;
  final Widget trailing;
  final Widget leading;
  final SystemUiOverlayStyle statusStyle;
  final Widget child; //child为自定义appBar,传child时其他参数无效(title, trailing, leading)

  @override
  _GmAppBarState createState() => _GmAppBarState();

  @override
  final Size preferredSize;

  final PreferredSizeWidget bottom;
}

class _GmAppBarState extends State<GMAppBar> {
  SystemUiOverlayStyle _overlayStyle = SystemUiOverlayStyle.light;
  MediaQueryData get mediaData => MediaQuery.of(context);

  List<Color> _appCodes;
  @override
  void initState() {
    super.initState();
    _appCodes = [Colors.white10, Colors.white10];
  }

  @override
  Widget build(BuildContext context) {
    final ModalRoute<dynamic> parentRoute = ModalRoute.of(context);
    final canPop = parentRoute?.canPop ?? false;

    Widget leading = widget.leading;

    if (leading == null && widget.automaticallyImplyLeading) {
      if (canPop) {
        leading = Material(
          color: Colors.transparent,
          child: GestureDetector(
            child: Container(
              color: Colors.transparent,
              alignment: Alignment(-0.6, 0),
              width: 70.0,
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: widget.actionSize,
              ),
            ),
            onTap: () {
              Navigator.maybePop(context);
            },
          ),
        );
      } else {
        leading = Container();
      }
    }

    if (leading != null) {
      leading = Align(
        alignment: AlignmentDirectional.centerStart,
        child: leading,
      );
    }
    return Semantics(
      container: true,
      explicitChildNodes: true,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: _overlayStyle,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: widget.backgroundColors ?? _appCodes,
              tileMode: TileMode.clamp,
            ),
          ),
          padding: EdgeInsets.only(top: mediaData.padding.top),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: widget.child ??
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        ConstrainedBox(
                          child: Container(
                              child: Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: Container(
                              child: leading,
                            ),
                          )),
                          constraints: BoxConstraints(minWidth: 70),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Text(
                              widget.title,
                              style: TextStyle(
                                  fontSize: 17.0,
                                  color: widget.titleColor,
                                  fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                            ),
                          ),
                        ),
                        ConstrainedBox(
                          child: Container(
                              child: Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: Container(
                              child: widget.trailing,
                            ),
                          )),
                          constraints: BoxConstraints(minWidth: 70),
                        )
                      ],
                    ),
              ),
              Container(
                child: widget.bottom,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
