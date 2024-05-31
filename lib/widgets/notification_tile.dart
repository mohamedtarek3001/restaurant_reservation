import 'package:flutter/material.dart';
// Assuming the model is in notification_model.dart
import 'package:intl/intl.dart';
import 'package:restaurant_reservation/models/notification_model.dart'; // For formatting the date

class NotificationTile extends StatelessWidget {
  final NotificationModel notification;

  NotificationTile({required this.notification});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        title: Text("new notification"),
        subtitle: Text(notification.text??'not available'),
        trailing: Text(DateFormat('yyyy-MM-dd HH:mm').format(DateTime.tryParse(notification.created??'')??DateTime.now())),
      ),
    );
  }
}