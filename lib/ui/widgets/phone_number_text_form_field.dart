import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhoneNumberTextFormField extends StatelessWidget {
  final void Function(String?)? onSaved;

  const PhoneNumberTextFormField({
    super.key,
    this.onSaved,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: const InputDecoration(
        labelText: 'Phone Number',
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      maxLength: 10,
      validator: (value) {
        final phoneNumber = value?.trim() ?? '';
        if (phoneNumber.isEmpty) {
          return 'Please enter your phone number';
        }
        if (phoneNumber.length < 9) {
          return 'Phone number must be at least 9 digits';
        }
        return null;
      },
      onSaved: onSaved,
    );
  }
}
