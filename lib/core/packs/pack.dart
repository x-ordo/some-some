class ContentPack {
  final int schemaVersion;
  final String id;
  final String name;
  final List<String> successLines;
  final List<String> failLines;

  const ContentPack({
    required this.id,
    required this.name,
    required this.successLines,
    required this.failLines,
    required this.schemaVersion,
  });

  factory ContentPack.fromJson(Map<String, dynamic> json) {
    return ContentPack(
      schemaVersion: (json['pack_schema_version'] ?? json['schemaVersion'] ?? 1) as int,
      id: (json['id'] ?? 'default').toString(),
      name: (json['name'] ?? 'Default').toString(),
      successLines: List<String>.from((json['successLines'] ?? json['success_lines']) ?? const ['천생연분!']),
      failLines: List<String>.from((json['failLines'] ?? json['fail_lines']) ?? const ['띠로리~']),
    );
  }
}
