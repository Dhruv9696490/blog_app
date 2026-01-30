import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscure;
   const AuthField({super.key, required this.controller, required this.hintText, this.obscure = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
        ),
      validator: (value){
          if(value!.isEmpty){
            return "$hintText is missing";
          }
          return null;
      },
      obscureText: obscure,
      obscuringCharacter: '*',
    );
  }
}
