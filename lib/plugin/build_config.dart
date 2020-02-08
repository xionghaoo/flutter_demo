import 'package:flutter/services.dart';

class BuildConfig {
  final MethodChannel _methodChannel;

  factory BuildConfig() {
    final MethodChannel methodChannel = MethodChannel("xh.zero/version");
    methodChannel.setMethodCallHandler((call) {
      print("call -> ${call.method}");
      // native返回值
      return Future.value("NativeCallFlutter");
    });
    return BuildConfig._internal(methodChannel);
  }

  BuildConfig._internal(this._methodChannel);

  Future<String> get applicationVersion => _methodChannel
      .invokeMethod<String>("getApplicationVersion")
      .then((dynamic result) => result);

}