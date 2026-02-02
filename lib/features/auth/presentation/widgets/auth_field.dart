import 'package:flutter/material.dart';

class AuthField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  const AuthField({
    super.key,
    required this.controller,
    required this.hintText,
    this.isPassword = false,
  });

  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  bool obsecure = true;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 70,
        width: 500,
        child: TextFormField(
          controller: widget.controller,
          decoration: InputDecoration(
            hintText: widget.hintText,
            suffix: widget.isPassword
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        obsecure = !obsecure;
                      });
                    },
                    icon: Icon(Icons.remove_red_eye_outlined,size: 16,),
                  )
                : null,
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return "${widget.hintText} is missing";
            }
            return null;
          },
          obscureText: widget.isPassword ? obsecure : false,
          obscuringCharacter: '*',
        ),
      ),
    );
  }
}
