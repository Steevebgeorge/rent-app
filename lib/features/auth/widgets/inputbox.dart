import 'package:flutter/material.dart';
import 'package:rent_app/constants/constants.dart';

class CustomTextField extends StatelessWidget {
  final bool isDark;
  final Size size;
  final String labelText;
  final IconData icon;
  final bool isPassword;
  final TextEditingController controller;

  const CustomTextField({
    super.key,
    required this.isDark,
    required this.size,
    required this.labelText,
    required this.icon,
    required this.isPassword,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? true : false,
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            color: isDark ? AppColors.darkTextColor : AppColors.lightTextColor,
          ),
          suffixIcon: Icon(icon,
              color: isDark ? AppColors.darkTextColor : Colors.purple),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
                color: isDark ? AppColors.darkTextColor : Colors.purple,
                width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
                color: isDark ? AppColors.darkTextColor : Colors.purple),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        ),
      ),
    );
  }
}
