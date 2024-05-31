import 'package:flutter/material.dart';

class RestaurantButton extends StatelessWidget {
  RestaurantButton({
    super.key,
    required this.title,
    required this.onPressed,
  });

  String? title;
  void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        minimumSize: Size(MediaQuery.of(context).size.width*0.3, 45),
        maximumSize: Size(MediaQuery.of(context).size.width*0.35, 45),
      ),
      onPressed: onPressed,
      child: Text(title ?? '', style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500)),
    );
  }
}
