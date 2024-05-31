import 'package:flutter/material.dart';
import 'package:restaurant_reservation/models/notification_model.dart';
import 'package:restaurant_reservation/widgets/notification_tile.dart';

class NotificationScreen extends StatelessWidget {
  NotificationScreen({Key? key,required this.notifications}) : super(key: key);
  late List<NotificationModel> notifications;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return NotificationTile(notification: notifications[index]);
        },
      ),
    );
  }
}
