import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({super.key, required this.node, required this.suffixIcon, this.title, this.hint, this.controller,this.validator});

  final FocusNode node;
  final Widget? suffixIcon;
  final String? title;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: TextFormField(
        controller: controller,
        focusNode: node,
        onTapOutside: (event) => node.unfocus(),
        validator: validator,
        decoration: InputDecoration(
            filled: true,
            hintText: hint,
            labelText: (title ?? ''),
            //floatingLabelBehavior: FloatingLabelBehavior.never,
            fillColor: Colors.grey[300],
            suffixIcon: suffixIcon,
            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(color: Colors.grey[300]!)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide(color: Colors.grey[300]!)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      ),
    );
  }
}