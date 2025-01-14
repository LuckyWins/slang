import 'dart:async';

import 'package:slang/api/locale.dart';

/// The [GlobalLocaleState] storing the global locale.
/// It is *shared* among all packages of an app.
class GlobalLocaleState {
  GlobalLocaleState._();

  static GlobalLocaleState instance = GlobalLocaleState._();

  final _controller = StreamController<BaseAppLocale>.broadcast();
  BaseAppLocale _currLocale = BaseAppLocale.undefinedLocale;

  BaseAppLocale getLocale() {
    return _currLocale;
  }

  void setLocale(BaseAppLocale locale) {
    if (locale == _currLocale) {
      return;
    }
    _currLocale = locale;
    _controller.add(locale);
  }

  Stream<BaseAppLocale> getStream() {
    return _controller.stream;
  }
}
