import 'package:flutter/material.dart';

class AuthBody extends StatelessWidget {
  AuthBody({
    super.key,
    required GlobalKey<FormState> formKey,
    required this.emailNode,
    required this.passNode,
    required this.child,
    required this.mainHeight,
    required this.secondaryHeight
  }) : _formKey = formKey;

  final GlobalKey<FormState> _formKey;
  final FocusNode emailNode;
  final FocusNode passNode;
  Widget? child;
  double? mainHeight;
  double? secondaryHeight;

  @override
  Widget build(BuildContext context) {
    return Stack(
      //fit: StackFit.expand,
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: mainHeight,
          width: MediaQuery.of(context).size.width,
        ),
        Container(
          height: secondaryHeight,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(5),
          margin: const EdgeInsets.only(left: 15, right: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
          ),
          child: child,
        ),
        const Positioned(
          top: 0,
          child: CircleAvatar(
            radius: 45,
            backgroundColor: Color(0xff104E41),
            child: Center(
              child: Icon(
                Icons.account_circle,
                size: 90,
                color: Colors.deepOrange,
              ),
            ),
          ),
        ),
      ],
    );
  }
}