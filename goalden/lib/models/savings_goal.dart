class SavingsGoal {
  final String id;
  final String title;
  final int targetCents;
  final int savedCents;

  const SavingsGoal({
    required this.id,
    required this.title,
    required this.targetCents,
    required this.savedCents,
  });

  factory SavingsGoal.fromMap(
    String id,
    Map<String, dynamic> data,
  ) {
    return SavingsGoal(
      id: id,
      title: data['title'] as String,
      targetCents: data['target_cents'] as int,
      savedCents: data['saved_cents'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'target_cents': targetCents,
      'saved_cents': savedCents,
    };
  }

  double get progress {
    if (targetCents <= 0) return 0;
    return (savedCents / targetCents).clamp(0.0, 1.0).toDouble();
  }
}