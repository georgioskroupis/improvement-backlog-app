class ImprovementItem {
  final String? id;
  final String title;
  final String impactLevel;
  final String champion;
  final String issue;
  final String improvement;
  final String outcome;
  final List<Map<String, dynamic>> feelings;

  ImprovementItem({
    this.id,
    required this.title,
    required this.impactLevel,
    required this.champion,
    required this.issue,
    required this.improvement,
    required this.outcome,
    List<Map<String, dynamic>>? feelings,
  }) : feelings = feelings ?? [];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'impactLevel': impactLevel,
      'champion': champion,
      'issue': issue,
      'improvement': improvement,
      'outcome': outcome,
      'feelings': feelings,
    };
  }

  factory ImprovementItem.fromMap(Map<String, dynamic> map) {
    return ImprovementItem(
      id: map['id'],
      title: map['title'] ?? '', // Provide default value if null
      impactLevel: map['impactLevel'] ?? '', // Provide default value if null
      champion: map['champion'] ?? '', // Provide default value if null
      issue: map['issue'] ?? '', // Provide default value if null
      improvement: map['improvement'] ?? '', // Provide default value if null
      outcome: map['outcome'] ?? '', // Provide default value if null
      feelings: map['feelings'] != null
          ? (map['feelings'] as List)
              .map((feeling) => Map<String, dynamic>.from(feeling))
              .toList()
          : [],
    );
  }
}
