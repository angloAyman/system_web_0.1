// stub version for Web

mixin WindowListener {}

class windowManager {
  static Future<void> ensureInitialized() async {}
  static void addListener(WindowListener listener) {}
  static void removeListener(WindowListener listener) {}
  static Future<void> destroy() async {}
  static Future<void> setPreventClose(bool value) async {}
  static Future<bool> isPreventClose() async => false;
}
