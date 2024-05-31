import 'package:flutter/material.dart';
import 'package:restaurant_reservation/models/menus_model.dart';

class MenuFormDialog extends StatefulWidget {
  final MenuModel menu;

  MenuFormDialog({required this.menu});

  @override
  _MenuFormDialogState createState() => _MenuFormDialogState();
}

class _MenuFormDialogState extends State<MenuFormDialog> {
  //late TextEditingController _idController;
  //late TextEditingController _restaurantController;
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    //_idController = TextEditingController(text: widget.menu.id.toString());
    //_restaurantController = TextEditingController(text: widget.menu.restaurant.toString());
    _nameController = TextEditingController(text: widget.menu.name);
    _descriptionController = TextEditingController(text: widget.menu.description);
    _priceController = TextEditingController(text: (widget.menu.price??0).toString());
  }

  @override
  void dispose() {
   // _idController.dispose();
    //_restaurantController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.menu.id == null?'Add Menu Item':'Edit Menu Item'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // TextFormField(
            //   controller: _idController,
            //   decoration: InputDecoration(labelText: 'ID'),
            //   readOnly: true,
            // ),
            // TextFormField(
            //   controller: _restaurantController,
            //   decoration: InputDecoration(labelText: 'Restaurant'),
            //   keyboardType: TextInputType.number,
            // ),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextFormField(
              controller: _priceController,
              decoration: InputDecoration(labelText: 'Price'),
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
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            widget.menu.name =  _nameController.text;
            widget.menu.description =  _descriptionController.text;
            widget.menu.price = (_priceController.text);
            print('Updated Menu: ${widget.menu.id}, ${widget.menu.restaurant}, ${widget.menu.name}, ${widget.menu.description}, ${widget.menu.price}');
            Navigator.of(context).pop(widget.menu);
            // You can add further logic to save the updated data to the server or database
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}