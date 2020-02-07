import 'package:flutter/services.dart';

class BuildConfig {
  final MethodChannel _methodChannel;

  factory BuildConfig() {
    final MethodChannel methodChannel = MethodChannel("xh.zero/version");
    return BuildConfig._internal(methodChannel);
  }

  BuildConfig._internal(this._methodChannel);

  Future<String> get applicationVersion => _methodChannel
      .invokeMethod<String>("getApplicationVersion")
      .then((dynamic result) => result);
}