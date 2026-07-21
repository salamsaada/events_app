class ChatUserModel {
  final String uid;
  final String name;
  final String email;
  final bool isOnline;
  final String role; // 'client', 'planner', 'company'

  ChatUserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.isOnline,
    required this.role,
  });

  // 🌟 الدالة الجديدة: لتحويل البيانات القادمة من الفايربيس إلى كائن
  factory ChatUserModel.fromJson(Map<String, dynamic> json) {
    return ChatUserModel(
      uid: json['uid'] ?? '', // نضع قيمة افتراضية لتجنب الانهيار إذا كان الحقل مفقوداً
      name: json['name'] ?? 'مستخدم',
      email: json['email'] ?? '',
      isOnline: json['is_online'] ?? false, // أهم حقل لدينا لاختبار البوت
      role: json['role'] ?? 'client',
    );
  }

  // الدالة القديمة: لتحويل الكائن إلى جيسون (في حال أردنا رفع بيانات للفايربيس)
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'is_online': isOnline,
      'role': role,
    };
  }
}