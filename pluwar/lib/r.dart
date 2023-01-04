import 'package:pluwar/platform/platform.dart';

class R {
  R._();

  static late final String appDir;
  static late final String tmpDir;
  static const packageName = "net.liplum.pluwar";

  static String get localStorageDir => isDesktop ? joinPath(appDir, packageName) : appDir;

  static String get hiveDir => joinPath(localStorageDir, "hive");

  /// For testing, it's my home LAN IP
  static const serverGameWebsocketUri = "ws://192.168.1.2:8080";

  /// For testing, it's my home LAN IP
  static const serverAuthUri = "http://192.168.1.2:8081";
}
