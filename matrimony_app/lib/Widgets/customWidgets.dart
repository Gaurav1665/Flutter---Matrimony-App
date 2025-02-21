import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomWidgets{

  Widget CustomInputField({
    required String label,
    required TextEditingController controller,
    bool obscureText = false,
    int? maxlen,
    TextInputType? inputType,
    TextCapitalization? textCapitalization,
    Icon? suffixIcon,
    Icon? prefixIcon,
    VoidCallback? iconOnPress,
    void Function(String)? onSubmitted,
    FormFieldValidator<String>? validator,
    List<TextInputFormatter>? inputFormatters
  }) {
    return TextFormField(
      obscureText: obscureText,
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      controller: controller,
      maxLength: maxlen,
      keyboardType: inputType,
      decoration: InputDecoration(
        prefixIcon: prefixIcon != null ? IconButton(icon: prefixIcon, onPressed: iconOnPress) : null,
        suffixIcon: suffixIcon != null ? IconButton(icon: suffixIcon, onPressed: iconOnPress) : null,
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
        labelText: label,
        hintText: label,
        counterText: "",
        labelStyle: TextStyle(color: Color(0xff2C2C2C)),
        hintStyle: TextStyle(color: Color(0xff708090)),
        filled: true,
        fillColor: Color(0xffF4F4F4),
        border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xffB0B0B0), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xff4B2F64), width: 2),
        ),
      ),
      style: TextStyle(color: Color(0xff2C2C2C)),
      onFieldSubmitted: onSubmitted,
      validator: validator,
      inputFormatters: inputFormatters,
    );
  }
  
}