String localizedText(
  Map<String, dynamic>? values,
  String languageCode, {
  String fallback = 'N/A',
}) {
  if (values == null || values.isEmpty) {
    return fallback;
  }

  final normalizedLanguage = languageCode.toLowerCase();
  final preferredKeys = normalizedLanguage.startsWith('ar')
      ? const ['ar', 'arabic']
      : const ['en', 'english'];

  for (final key in preferredKeys) {
    final value = values[key];
    if (value is String && value.trim().isNotEmpty) {
      return value;
    }
  }

  for (final value in values.values) {
    if (value is String && value.trim().isNotEmpty) {
      return value;
    }
  }

  return fallback;
}
