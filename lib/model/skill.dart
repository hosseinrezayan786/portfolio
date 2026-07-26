class Skill {
  final String name;
  final String? iconKey;
  final int? accentColor;

  const Skill({required this.name, this.iconKey, this.accentColor});

  factory Skill.fromMap(Map<String, dynamic> map) {
    return Skill(
      name: map['name'] as String,
      iconKey: map['iconKey'] as String?,
      accentColor: map['accentColor'] as int?,
    );
  }
}
