class PlannerModel {
  final String id;
  final String name;
  final String type;
  final String role; 

  PlannerModel({required this.id, required this.name, required this.type, required this.role});

  factory PlannerModel.fromJson(Map<String, dynamic> json) {
    return PlannerModel(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unknown',
      type: json['type'] ?? 'freelancer',
      // إذا لم يرسل الباك إند دوراً، نعوضه بناءً على النوع
      role: json['type'] == 'company' ? 'Company' : 'Freelancer', 
    );
  }
}