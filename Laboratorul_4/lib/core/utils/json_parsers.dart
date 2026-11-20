typedef JsonMap = Map<String, dynamic>;

double parseDouble(dynamic value, [double fallback = 0.0]) {
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? fallback;
  return fallback;
}

int parseInt(dynamic value, [int fallback = 0]) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? fallback;
  return fallback;
}

List<JsonMap> asMapList(dynamic raw) {
  if (raw is! List) return const [];
  final result = <JsonMap>[];
  for (final item in raw) {
    if (item is JsonMap) {
      result.add(item);
    } else if (item is Map) {
      result.add(JsonMap.from(item));
    }
  }
  return result;
}
