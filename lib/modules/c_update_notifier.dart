import 'dart:math';

export '' show CUpdateNotifier;

/// Use to raise execution of some methods in all
/// widget that register this notifier.
class CUpdateNotifier {
  static CUpdateNotifier? _inst;
  CUpdateNotifier._();
  static CUpdateNotifier get inst => _inst ??= CUpdateNotifier._();
  static CUpdateNotifier get i => _inst ??= CUpdateNotifier._();
  //||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

  Map<String, void Function(dynamic data)> notifiers = {};

  /// Generates a random string of a given length.
  String _generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(length, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }

  /// Register a new callback via it's key name.
  ///
  /// It is very indispensable to dispose a notifier when it parent is disposed.
  static DisposeUpdateNotifier registerNotifier(String keyName, void Function(dynamic) notifier) {
    var instance = CUpdateNotifier.inst;

    String groupKey = instance._generateRandomString(18);
    keyName = "$groupKey---$keyName";

    instance.notifiers[keyName] = notifier;

    return DisposeUpdateNotifier(groupKey);
  }

  /// Register a new group of callbacks via it's key name.
  ///
  /// It is very indispensable to dispose a notifier when it parent is disposed.
  static DisposeUpdateNotifier registerNotifiers(Map<String, void Function(dynamic)> notifiers) {
    var instance = CUpdateNotifier.inst;

    String groupKey = instance._generateRandomString(18);
    for (String keyName in notifiers.keys) {
      keyName = "$groupKey---$keyName";
      instance.notifiers[keyName] = notifiers[keyName]!;
    }

    return DisposeUpdateNotifier(groupKey);
  }

  /// Notify a callback via it's key name.
  ///
  /// Some time error can be raised, please verify if called callback is still valid.
  /// But parent can be disposed.
  ///
  /// If two element have same key name, the last one will be used.
  static void notify(String keyName, [dynamic data]) {
    var instance = CUpdateNotifier.inst;

    String keyName0 = '';
    for (String key in instance.notifiers.keys) {
      List<String> splied = key.split('---');
      if (keyName == (splied.elementAtOrNull(1) ?? splied.first)) {
        if (instance.notifiers.containsKey(key)) keyName0 = key;
      }
    }
    if (keyName0 == '') return;

    instance.notifiers[keyName0]?.call(data);
  }

  /// Notify a group of callbacks via it's key names.
  static void notifyAGroup(Map<String, dynamic> keyNames, [dynamic data]) {
    var instance = CUpdateNotifier.inst;

    for (String keyName in keyNames.keys) {
      String keyName0 = '';
      for (String key in instance.notifiers.keys) {
        List<String> splied = key.split('---');
        if (keyName == (splied.elementAtOrNull(1) ?? splied.first)) {
          if (instance.notifiers.containsKey(key)) keyName0 = key;
        }
      }
      if (keyName0 == '') return;

      instance.notifiers[keyName0]?.call(data);
    }
  }
}

/// Dispose update notifier.
class DisposeUpdateNotifier {
  DisposeUpdateNotifier(String groupKeyName) : _groupKeyName = groupKeyName;

  /// Notifier group name.
  final String _groupKeyName;

  /// Dispose update notifiers.
  void dispose() {
    for (String key in CUpdateNotifier.inst.notifiers.keys) {
      List<String> splied = key.split('---');
      if (_groupKeyName == (splied.elementAtOrNull(0) ?? '')) {
        if (CUpdateNotifier.inst.notifiers.containsKey(key)) {
          CUpdateNotifier.inst.notifiers.remove(key);
        }
      }
    }
  }
}
