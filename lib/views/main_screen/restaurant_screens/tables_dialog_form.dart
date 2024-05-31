import 'package:flutter/material.dart';
import 'package:restaurant_reservation/models/tables_model.dart';

class TableFormDialog extends StatefulWidget {
  final TablesModel table;

  TableFormDialog({required this.table});

  @override
  _TableFormDialogState createState() => _TableFormDialogState();
}

class _TableFormDialogState extends State<TableFormDialog> {
  //late TextEditingController _idController;
  late TextEditingController _tableNumberController;
  late TextEditingController _capacityController;
  //late TextEditingController _restaurantController;
  bool _isReserved = false;

  @override
  void initState() {
    super.initState();
    //_idController = TextEditingController(text: widget.table.id.toString());
    _tableNumberController = TextEditingController(text: widget.table.tableNumber);
    _capacityController = TextEditingController(text: (widget.table.capacity??'0').toString());
    //_restaurantController = TextEditingController(text: widget.table.restaurant.toString());
    _isReserved = widget.table.isReserved??false;
  }

  @override
  void dispose() {
    //_idController.dispose();
    _tableNumberController.dispose();
    _capacityController.dispose();
    //_restaurantController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.table.id == null?'Add Table':'Edit Table'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // TextFormField(
            //   controller: _idController,
            //   decoration: InputDecoration(labelText: 'ID'),
            //   readOnly: true,
            // ),
            SwitchListTile(
              title: Text('Reserved'),
              value: _isReserved,
              onChanged: (bool value) {
                setState(() {
                  _isReserved = value;
                });
              },
            ),
            TextFormField(
              controller: _tableNumberController,
              decoration: InputDecoration(labelText: 'Table Number'),
            ),
            TextFormField(
              controller: _capacityController,
              decoration: InputDecoration(labelText: 'Capacity'),
              keyboardType: TextInputType.number,
            ),
            // TextFormField(
            //   controller: _restaurantController,
            //   decoration: InputDecoration(labelText: 'Restaurant'),
            //   keyboardType: TextInputType.number,
            // ),
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
            widget.table.tableNumber = _tableNumberController.text;
            widget.table.isReserved = _isReserved;
            widget.table.capacity = int.parse(_capacityController.text);

            print('Updated Table: ${widget.table.id}, ${widget.table.isReserved}, ${widget.table.tableNumber}, ${widget.table.capacity}, ${widget.table.restaurant}');
            Navigator.of(context).pop(widget.table);
            // You can add further logic to save the updated data to the server or database
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}