class ImprovementItem {
  final String? id;
  final String title;
  final String impactLevel;
  final String champion;
  final String issue;
  final String improvement;
  final String outcome;
  final List<Map<String, dynamic>> feelings; // New field to represent feelings

  ImprovementItem({
    this.id,
    required this.title,
    required this.impactLevel,
    required this.champion,
    required this.issue,
    required this.improvement,
    required this.outcome,
    required this.feelings,
  });

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
      title: map['title'],
      impactLevel: map['impactLevel'],
      champion: map['champion'],
      issue: map['issue'],
      improvement: map['improvement'],
      outcome: map['outcome'],
      feelings: List<Map<String, dynamic>>.from(map['feelings'] ?? []),
    );
  }
}
