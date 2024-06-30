import 'package:flutter/material.dart';

class CreditCardPaymentForm extends StatefulWidget {
  const CreditCardPaymentForm({super.key,required this.totalPrice});
  final totalPrice;


  @override
  _CreditCardPaymentFormState createState() => _CreditCardPaymentFormState();
}

class _CreditCardPaymentFormState extends State<CreditCardPaymentForm> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();
  final _cardHolderNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _cardNumberController,
              decoration: const InputDecoration(labelText: 'Card Number'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter card number';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _expiryDateController,
              decoration: const InputDecoration(labelText: 'Expiry Date (MM/YY)'),
              keyboardType: TextInputType.datetime,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter expiry date';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _cvvController,
              decoration: const InputDecoration(labelText: 'CVV'),
              keyboardType: TextInputType.number,
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter CVV';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _cardHolderNameController,
              decoration: const InputDecoration(labelText: 'Cardholder Name'),
              keyboardType: TextInputType.name,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter cardholder name';
                }
                return null;
              },
            ),
            SizedBox(height: 25,),
            Text("Total price is : ${widget.totalPrice} EGP"),
          ],
        ),
      ),
    );
  }
}