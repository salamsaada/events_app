class ListingModel {
  final String id;
  final String title;
  final String? description;
  final String? coverImage;
  final String? categoryName;
  final String? districtName;
  final double? price;
  bool isFavorite; // 🌟 ليست final لأننا سنغيرها محلياً عند الضغط على القلب

  ListingModel({
    required this.id,
    required this.title,
    this.description,
    this.coverImage,
    this.categoryName,
    this.districtName,
    this.price,
    this.isFavorite = false,
  });

  factory ListingModel.fromJson(Map<String, dynamic> json) {
    // 1. استخراج الصورة الأساسية
    String? imageUrl;
    if (json['images'] != null && (json['images'] as List).isNotEmpty) {
      imageUrl = json['images'][0]['url'] ?? json['images'][0]['image_path'] ?? json['images'][0].toString(); 
    }

    // 2. استخراج اسم التصنيف من العلاقة
    String? category;
    if (json['category'] != null) {
      category = json['category']['name'] ?? json['category']['title'];
    }

    // 3. استخراج اسم المنطقة من العلاقة
    String? district;
    if (json['district'] != null) {
      district = json['district']['name'];
    }

    // === 🚀 هنا الإصلاح السحري لمشكلة الـ Map والـ String ===
    
    // دالة صغيرة لاستخراج النص سواء كان Map أو String
    String parseText(dynamic value, String fallback) {
      if (value is Map) {
        return value['ar'] ?? value['en'] ?? fallback;
      }
      return value?.toString() ?? fallback;
    }

    return ListingModel(
      id: json['id'].toString(),
      
      // استخدام الدالة الجديدة لحل الخطأ تماماً
      title: parseText(json['title'] ?? json['name'], 'بدون عنوان'), 
      description: parseText(json['description'], ''),
      
      coverImage: imageUrl,
      categoryName: category,
      districtName: district,
      price: json['price'] != null ? double.tryParse(json['price'].toString()) : null,
      isFavorite: json['is_favorited'] ?? true, // بما أنها في صفحة المفضلة، فهي مفضلة بالتأكيد
    );
  }
}