import 'package:flutter/material.dart';

class CustomWidgets{

  Widget CustomInputField({
    required String label,
    required TextEditingController controller,
    bool obscureText = false,
    TextInputType? inputType,
    TextCapitalization? textCapitalization,
    Icon? suffixIcon,
    Icon? prefixIcon,
    VoidCallback? iconOnPress,
    void Function(String)? onSubmitted,
    FormFieldValidator<String>? validator,
  }) {
    return TextFormField(
      obscureText: obscureText,
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        prefixIcon: prefixIcon != null ? IconButton(icon: prefixIcon, onPressed: iconOnPress) : null,
        suffixIcon: suffixIcon != null ? IconButton(icon: suffixIcon, onPressed: iconOnPress) : null,
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        labelText: label,
        hintText: label,
      ),
      onFieldSubmitted: onSubmitted,
      validator: validator,
    );
  }
  
}