import 'package:flutter/material.dart';
 

class CustomGoldButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final double width;
  final IconData? icon;

  const CustomGoldButton({
    super.key,
    required this.text,
    required this.onTap,
    this.width = double.infinity, 
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 55,
      child: ElevatedButton(
        onPressed: onTap,
        child: Text(
          text,
          style: Theme.of(context).elevatedButtonTheme.style?.textStyle?.resolve({}) ?? const TextStyle(),
        ),
      ),
    );
  }
}