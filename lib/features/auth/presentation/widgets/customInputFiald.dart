import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final String? Function(String?)? validator;
  final bool isPassword;
  final bool obscureText;
  final VoidCallback? toggle;
  final TextInputType keyboardType;

  const CustomInputField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.validator,
    this.isPassword = false,
    this.obscureText = false,
    this.toggle,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        

        // FormField so validator 
        FormField<String>(
          initialValue: controller.text,
          validator: validator,
          builder: (field) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12)),
                  child: TextField(
                    controller: controller,
                    keyboardType: keyboardType,
                    obscureText: obscureText,
                    onChanged: (v) => field.didChange(v), 
                    decoration: InputDecoration(
                      hintText: hint,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      suffixIcon: isPassword
                          ? IconButton(
                              icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                              onPressed: toggle,
                            )
                          : null,
                    ),
                  ),
                ),

                // error message 
                if (field.errorText != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 6, left: 6),
                    child: Text(field.errorText!, style: const TextStyle(color: Colors.red, fontSize: 12)),
                  ),
              ],
            );
          },
        ),

        const SizedBox(height: 15),
      ],
    );
  }
}