import 'package:flutter/material.dart';
import 'package:restaurant_reservation/models/street_model.dart';

class CustomStreetDropMenu extends StatelessWidget {
  CustomStreetDropMenu({super.key, required this.list,required this.onChanged,required this.street});

  List<StreetModel> list = [];
  StreetModel? street;
  void Function(StreetModel?)? onChanged;

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
        child: DropdownButton<StreetModel>(
          value: street,
          hint: Text('Choose your street'),
          isExpanded: true,
          underline: SizedBox(),
          items: list
              .map(
                (e) => DropdownMenuItem(
              value: e,
              child: Text(e.streetName ?? ''),
            ),
          )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}