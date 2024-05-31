import 'package:flutter/material.dart';
import 'package:restaurant_reservation/models/desert_model.dart';

class DessertFormDialog extends StatefulWidget {
  final DesertModel dessert;

  const DessertFormDialog({required this.dessert});

  @override
  _DessertFormDialogState createState() => _DessertFormDialogState();
}

class _DessertFormDialogState extends State<DessertFormDialog> {
  //late TextEditingController _restaurantController;
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    //_restaurantController = TextEditingController(text: widget.dessert.restaurant.toString());
    _nameController = TextEditingController(text: widget.dessert.name);
    _descriptionController = TextEditingController(text: widget.dessert.description);
    _priceController = TextEditingController(text: (widget.dessert.price??0).toString());
  }

  @override
  void dispose() {
    //_restaurantController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.dessert.id == null?'Add Dessert':'Edit Dessert'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // TextFormField(
            //   controller: _restaurantController,
            //   decoration: const InputDecoration(labelText: 'Restaurant'),
            //   keyboardType: TextInputType.number,
            // ),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextFormField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            widget.dessert.name = _nameController.text;
            widget.dessert.description = _descriptionController.text;

            widget.dessert.price = (_priceController.text);

            print('Updated Dessert: ${widget.dessert.restaurant}, ${widget.dessert.name}, ${widget.dessert.description}, ${widget.dessert.price}');
            Navigator.of(context).pop(widget.dessert);
            // You can add further logic to save the updated data to the server or database
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}