class PlannerModel {
  final String id;
  final String name;
  final String type;
  final String role; 
  
  // 🚀 الحقول الجديدة اللي ضفناها
  final String rating;
  final String email;
  final String phone;
  final bool isVerified;

  PlannerModel({
    required this.id, 
    required this.name, 
    required this.type, 
    required this.role,
    required this.rating,
    required this.email,
    required this.phone,
    required this.isVerified,
  });

  factory PlannerModel.fromJson(Map<String, dynamic> json) {
    // 1. استخراج كائن الـ user لأنه بيحتوي على الإيميل والرقم
    final user = json['user'] ?? {};

    // 2. معالجة الاسم بذكاء:
    // رح يدور على brand_name (من التفاصيل) أو name (من القائمة)
    String fetchedName = json['brand_name'] ?? json['name'] ?? '';
    // إذا التنين فاضيين، رح ياخد الاسم الأول والأخير من كائن اليوزر
    if (fetchedName.isEmpty) {
      final firstName = user['first_name'] ?? '';
      final lastName = user['last_name'] ?? '';
      fetchedName = '$firstName $lastName'.trim();
    }
    // إذا كله فاضي بنحط قيمة افتراضية
    if (fetchedName.isEmpty) fetchedName = 'بدون اسم';

    // 3. معالجة النوع: من التفاصيل (provider_type) أو من القائمة (type)
    String fetchedType = json['provider_type'] ?? json['type'] ?? 'freelancer';

    return PlannerModel(
      id: json['id'] ?? '',
      name: fetchedName,
      type: fetchedType,
      role: fetchedType == 'company' ? 'Company' : 'Freelancer',
      
      // 🚀 ربط الحقول الجديدة:
      rating: json['rating']?.toString() ?? '0.00',
      email: user['email'] ?? 'بدون إيميل',
      phone: user['phone']?.toString() ?? 'غير متوفر',
      
      // الباك إند عم يرسل is_verified كـ 0 أو 1، فبنتأكد منها هيك:
      isVerified: json['is_verified'] == 1 || json['is_verified'] == true,
    );
  }
}