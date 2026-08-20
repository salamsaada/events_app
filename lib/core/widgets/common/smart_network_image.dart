import 'package:eventsapp/core/services/image_helper.dart';
import 'package:flutter/material.dart';
import 'package:eventsapp/models/listing_model.dart';

/// ويدجت صورة ذكية للصالات:
/// 1. تعرض صورة الباك إذا موجودة وشكلها صحيح.
/// 2. إذا مافي صورة من الباك أصلاً => تعرض صورة بديلة فوراً.
/// 3. إذا صورة الباك موجودة بس فشلت بالتحميل فعلياً (404، رابط منتهي...)
///    => ترجع تلقائياً لصورة بديلة بدل أيقونة "صورة مكسورة".
class SmartNetworkImage extends StatelessWidget {
  final ServiceItem item;
  final double? height;
  final double? width;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const SmartNetworkImage({
    super.key,
    required this.item,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final String? backendUrl = ImageHelper.extractBackendUrl(item);
    final String fallbackUrl = ImageHelper.getFallbackImage(item.id);
    final String primaryUrl = backendUrl ?? fallbackUrl;

    Widget image = Image.network(
      primaryUrl,
      height: height,
      width: width,
      fit: fit,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return _loadingPlaceholder();
      },
      errorBuilder: (context, error, stackTrace) {
        // إذا كنا أصلاً عم نعرض الصورة البديلة وفشلت، اعرض placeholder ثابت
        if (primaryUrl == fallbackUrl) return _brokenPlaceholder();

        // صورة الباك فشلت فعلياً بالتحميل => ارجع لصورة بديلة
        return Image.network(
          fallbackUrl,
          height: height,
          width: width,
          fit: fit,
          errorBuilder: (context, error, stackTrace) => _brokenPlaceholder(),
        );
      },
    );

    if (borderRadius != null) {
      image = ClipRRect(borderRadius: borderRadius!, child: image);
    }

    return image;
  }

  Widget _loadingPlaceholder() {
    return Container(
      height: height,
      width: width,
      color: Colors.grey[200],
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  Widget _brokenPlaceholder() {
    return Container(
      height: height,
      width: width,
      color: Colors.grey[200],
      child: const Icon(Icons.broken_image, color: Colors.grey, size: 40),
    );
  }
}