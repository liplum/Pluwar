import 'dart:convert';

extension JsonConvert on String {
  T? fromJson<T>(T Function(Map<String, dynamic>) fromJsonFunc) {
    try {
      final json = jsonDecode(this);
      return fromJsonFunc(json);
    } catch (_) {
      return null;
    }
  }
}
