class Country {
  final String name;
  final String cca2;

  Country({required this.name, required this.cca2});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name']?['common'] ?? 'Unknown',
      cca2: json['cca2'] ?? '',
    );
  }

  String get flagUrl => 'https://flagcdn.com/w320/$cca2.png';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Country &&
          runtimeType == other.runtimeType &&
          cca2 == other.cca2;

  @override
  int get hashCode => cca2.hashCode;
}
