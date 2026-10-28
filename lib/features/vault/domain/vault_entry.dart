import 'dart:convert';

final class VaultEntry {
  const VaultEntry({
    required this.id,
    required this.title,
    required this.password,
    this.username = '',
    this.url = '',
    this.notes = '',
    this.tags = const <String>[],
    this.favorite = false,
    this.riskScore = 0,
    this.breachCount,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String title;
  final String username;
  final String password;
  final String url;
  final String notes;
  final List<String> tags;
  final bool favorite;
  final int riskScore;
  final int? breachCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get breached => (breachCount ?? 0) > 0;

  VaultEntry copyWith({
    String? id,
    String? title,
    String? username,
    String? password,
    String? url,
    String? notes,
    List<String>? tags,
    bool? favorite,
    int? riskScore,
    int? breachCount,
    bool clearBreachCount = false,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => VaultEntry(
    id: id ?? this.id,
    title: title ?? this.title,
    username: username ?? this.username,
    password: password ?? this.password,
    url: url ?? this.url,
    notes: notes ?? this.notes,
    tags: tags ?? this.tags,
    favorite: favorite ?? this.favorite,
    riskScore: riskScore ?? this.riskScore,
    breachCount: clearBreachCount ? null : breachCount ?? this.breachCount,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  Map<String, Object?> toJson() => <String, Object?>{
    'id': id,
    'title': title,
    'username': username,
    'password': password,
    'url': url,
    'notes': notes,
    'tags': tags,
    'favorite': favorite,
    'riskScore': riskScore,
    'breachCount': breachCount,
    'createdAt': createdAt.toUtc().toIso8601String(),
    'updatedAt': updatedAt.toUtc().toIso8601String(),
  };

  factory VaultEntry.fromJson(Map<String, dynamic> json) {
    final title = json['title'];
    final password = json['password'];
    if (title is! String || title.trim().isEmpty || password is! String) {
      throw const FormatException('Invalid vault item.');
    }
    return VaultEntry(
      id: json['id'] as String,
      title: title.trim(),
      username: json['username'] as String? ?? '',
      password: password,
      url: json['url'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      tags: (json['tags'] as List<dynamic>? ?? const <dynamic>[])
          .whereType<String>()
          .map((tag) => tag.trim())
          .where((tag) => tag.isNotEmpty)
          .toSet()
          .toList(growable: false),
      favorite: json['favorite'] as bool? ?? false,
      riskScore: (json['riskScore'] as num?)?.toInt().clamp(0, 100) ?? 0,
      breachCount: (json['breachCount'] as num?)?.toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  String encodePayload() => jsonEncode(toJson());
}
