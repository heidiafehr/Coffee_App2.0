import 'package:coffee_app_2/app_colors.dart';
import 'package:flutter/material.dart';

class CustomRefreshButton extends StatelessWidget {
  const CustomRefreshButton({super.key, required this.onPressed});

  final VoidCallback onPressed;
  
  get generateBloc => null;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(12),
          color: AppColors.cream,
          border: Border.all(color: AppColors.darkBrown, width: 2),
          boxShadow: [
            BoxShadow(color: AppColors.darkBrown, offset: Offset(4, 4)),
          ],
        ),
        child: IconButton(
          icon: Icon(Icons.refresh_rounded, color: AppColors.darkBrown),
          iconSize: 28,
          onPressed: onPressed,
        ),
      ),
    );
  }
}
