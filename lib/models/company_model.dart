enum CompanyPlan {
  basic,
  premium,
  enterprise,
}

class CompanyModel {
  final String id;
  final String name;
  final String domain;
  final CompanyPlan plan;
  final DateTime createdAt;

  CompanyModel({
    required this.id,
    required this.name,
    required this.domain,
    required this.plan,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'domain': domain,
      'plan': plan.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id'] as String,
      name: json['name'] as String,
      domain: json['domain'] as String,
      plan: CompanyPlan.values.byName(json['plan'] as String? ?? 'basic'),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
