/// Admin-curated, universal reason a vendor can attach to a flagged line
/// item during order reconciliation (re-evaluation) — e.g. "Damaged Item".
/// Fetched from `GET /reconciliation-problem-types/active`. Plain class
/// (not Freezed) — small, read-only reference data, same pattern as
/// [ReclassifyOption].
class ReconciliationProblemType {
  const ReconciliationProblemType({
    required this.id,
    required this.label,
    this.description,
  });

  factory ReconciliationProblemType.fromJson(Map<String, dynamic> json) {
    return ReconciliationProblemType(
      id: json['id'] as String? ?? '',
      label: json['label'] as String? ?? '',
      description: json['description'] as String?,
    );
  }

  final String id;
  final String label;
  final String? description;
}
