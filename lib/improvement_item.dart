// lib/improvement_item.dart
class ImprovementItem {
  final int? id;
  final String title;
  final String impactLevel;
  final String champion;
  final String issue;
  final String improvement;
  final String outcome;
  final String feeling;

  ImprovementItem({
    this.id,
    required this.title,
    required this.impactLevel,
    required this.champion,
    required this.issue,
    required this.improvement,
    required this.outcome,
    required this.feeling,
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
      'feeling': feeling,
    };
  }
}
