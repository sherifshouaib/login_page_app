import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomFormTextField extends StatelessWidget {
  CustomFormTextField(
      {this.hintText,
      this.onChanged,
      this.icon,
      this.iconpasswordcontainer,
      obscureText});
  Function(String)? onChanged;
  IconButton? iconpasswordcontainer;
  String? hintText;
  Widget? icon;

  static bool obscureText =
      false; // لازم تدى ال static variable قيمة وألا هيدى exception
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText!,
      validator: (data) {
        if (hintText == 'Email') {
          if (data!.isEmpty) {
            return 'field is required';
          } else if (!RegExp(r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$')
              .hasMatch(data)) {
            return 'Please enter a valid email';
          }
          return null;
        }
      },
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xffEBEBEBFF),    // نستخدم ال  filled , fillColor لتغيير backgroundcolor of textfield
        hintText: hintText,
        prefixIcon: icon,
        suffixIcon: iconpasswordcontainer,
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
