import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AuthGradientButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  const AuthGradientButton({super.key, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [AppPallete.gradient1,AppPallete.gradient2],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight
        ),
          borderRadius: BorderRadius.circular(8)
      ),
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            fixedSize: Size(500, 57),
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
          ),
          child: Text(title,style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold
          ),),
      ),
    );
  }
}
