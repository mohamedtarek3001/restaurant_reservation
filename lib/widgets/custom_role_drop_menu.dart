import 'package:flutter/material.dart';

class CustomRoleDropMenu extends StatelessWidget {
  CustomRoleDropMenu({super.key, required this.list,required this.onChanged,required this.role});

  List<String> list = [];
  String? role;
  void Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: InputDecorator(
        decoration: InputDecoration(
            filled: true,
            //floatingLabelBehavior: FloatingLabelBehavior.never,
            fillColor: Colors.grey[300],
            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey[300]!)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey[300]!)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
        child: DropdownButton<String>(
          value: role,
          hint: Text('Choose your role'),
          isExpanded: true,
          underline: SizedBox(),
          items: list
              .map(
                (e) => DropdownMenuItem(
              value: e,
              child: Text(e ?? ''),
            ),
          )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}