import 'package:flutter/material.dart';

class PasswordTextFormField extends StatelessWidget {
  final String labelText;
  final void Function(String?)? onSaved;

  const PasswordTextFormField({
    super.key,
    required this.labelText,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: labelText,
      ),
      maxLength: 8,
      validator: (value) {
        final password = value?.trim() ?? '';
        if (password.isEmpty) {
          return 'Please enter your password';
        }
        if (password.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
      onSaved: onSaved,
    );
  }
}
