import 'package:flutter/material.dart';
import 'package:restaurant_reservation/models/city_model.dart';

class CustomCityDropMenu extends StatelessWidget {
  CustomCityDropMenu({super.key, required this.list,required this.onChanged,required this.city});

  List<CityModel> list = [];
  CityModel? city;
  void Function(CityModel?)? onChanged;

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
        child: DropdownButton<CityModel>(
          value: city,
          hint: Text('Choose your city'),
          isExpanded: true,
          underline: SizedBox(),
          items: list
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e.cityname ?? ''),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
