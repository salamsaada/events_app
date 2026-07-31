import 'package:eventsapp/cubit/favorites_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteButton extends StatefulWidget {
  final String listingId;
  final bool initialIsFavorite;

  const FavoriteButton({
    super.key,
    required this.listingId,
    required this.initialIsFavorite,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.initialIsFavorite;
  }

  // 🚀 التعديل السحري: إجبار الزر على استماع التحديثات القادمة من الكيوبيت عند الرجوع للصفحة
  @override
  void didUpdateWidget(covariant FavoriteButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialIsFavorite != widget.initialIsFavorite) {
      setState(() {
        isFavorite = widget.initialIsFavorite;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? Colors.red : Colors.grey,
      ),
      onPressed: () {
        // 1. التحديث المتفائل: تغيير الحالة محلياً فوراً
        setState(() {
          isFavorite = !isFavorite;
        });

        // 2. استدعاء الكيوبيت لإخبار السيرفر
        context.read<FavoritesCubit>().toggleHeart(widget.listingId).catchError((e) {
          // 3. في حالة فشل السيرفر، نعيد الحالة السابقة
          setState(() {
            isFavorite = !isFavorite;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("فشل الاتصال، حاول مجدداً")),
          );
        });
      },
    );
  }
}