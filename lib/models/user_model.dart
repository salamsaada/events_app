class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone; 
  final String role;
  
  UserModel({
    required this.id, 
    required this.firstName, 
    required this.lastName, 
    required this.email, 
    this.phone, 
    required this.role
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // 1. استخراج الدور (Role) بشكل صحيح من المصفوفة إذا كانت موجودة
    String extractedRole = 'organizer';
    if (json['roles'] != null && (json['roles'] as List).isNotEmpty) {
      extractedRole = json['roles'][0]['name'] ?? 'organizer';
    }

    return UserModel(
      // 2. إضافة حماية (??) لجميع الحقول الأساسية لمنع الانهيار
      id: json['id'] ?? '', 
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'], // هذا مسموح لأن المتغير معرّف كـ String?
      role: extractedRole, 
    );
  }
}