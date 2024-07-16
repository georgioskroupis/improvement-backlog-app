// lib/improvement_item.dart
class ImprovementItem {
  final int id;
  final String title;
  final String impactLevel;
  final String champion;
  final String issue;
  final String improvement;
  final String outcome;
  final String feeling;

  ImprovementItem({
    required this.id,
    required this.title,
    required this.impactLevel,
    required this.champion,
    required this.issue,
    required this.improvement,
    required this.outcome,
    required this.feeling,
  });

  ImprovementItem copyWith({
    int? id,
    String? title,
    String? impactLevel,
    String? champion,
    String? issue,
    String? improvement,
    String? outcome,
    String? feeling,
  }) {
    return ImprovementItem(
      id: id ?? this.id,
      title: title ?? this.title,
      impactLevel: impactLevel ?? this.impactLevel,
      champion: champion ?? this.champion,
      issue: issue ?? this.issue,
      improvement: improvement ?? this.improvement,
      outcome: outcome ?? this.outcome,
      feeling: feeling ?? this.feeling,
    );
  }

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
