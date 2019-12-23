import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
export 'package:provider/provider.dart' show ChangeNotifierProvider;

class Store {
  static provider({List<SingleChildCloneableWidget> providers, Widget child}) {
    return MultiProvider(providers: providers, child: child);
  }

  //  通过Provider.value<T>(context)获取状态数据
  static T value<T>(context, {listen: true}) {
    return Provider.of<T>(context, listen: listen);
  }

  /// 通过Consumer获取状态数据
  static Consumer connect<T>(
      {builder(BuildContext context, T value, Widget child), child}) {
    return Consumer<T>(builder: builder, child: child);
  }
}
