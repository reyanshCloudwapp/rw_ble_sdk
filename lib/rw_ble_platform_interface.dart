import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'rw_ble_method_channel.dart';

abstract class RwBlePlatform extends PlatformInterface {
  /// Constructs a RwBlePlatform.
  RwBlePlatform() : super(token: _token);

  static final Object _token = Object();

  static RwBlePlatform _instance = MethodChannelRwBle();

  /// The default instance of [RwBlePlatform] to use.
  ///
  /// Defaults to [MethodChannelRwBle].
  static RwBlePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [RwBlePlatform] when
  /// they register themselves.
  static set instance(RwBlePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
