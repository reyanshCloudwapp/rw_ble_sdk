import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'rw_ble_platform_interface.dart';

/// An implementation of [RwBlePlatform] that uses method channels.
class MethodChannelRwBle extends RwBlePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('rw_ble');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
