import 'package:flutter/material.dart';

class BlogEditorField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  const BlogEditorField({super.key, required this.controller, required this.hint});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint
      ),
      validator: (value){
        if(value!.isEmpty){
          return '$hint is missing';
        }
        return null;
      },
      maxLines: null,
    );
  }
}
