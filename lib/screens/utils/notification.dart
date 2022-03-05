import 'package:flutter/material.dart';

class Notify extends StatefulWidget {
  const Notify({Key? key}) : super(key: key);

  @override
  State<Notify> createState() => _NotifyState();
}

List<String> notifications = [
  "2000/- transferred from Kowsik",
  "your post was liked",
  "your service request has been approved"
];
List<int> notificationsDay = [1, 5, 4];

List<int> notificationsType = [1, 0, 2];

class _NotifyState extends State<Notify> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inbox"),
      ),
      body: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: notificationsType[index] == 0
                  ? const Icon(
                      Icons.volunteer_activism,
                      color: Colors.pink,
                    )
                  : notificationsType[index] == 1
                      ? const Icon(
                          Icons.account_balance,
                          color: Colors.blueAccent,
                        )
                      : const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
              title: Text(notifications[index]),
              subtitle: Text(
                notificationsDay[index].toString() + "D",
                style: const TextStyle(color: Colors.grey),
              ),
              trailing: IconButton(
                icon: const Icon(
                  Icons.more_vert,
                ),
                onPressed: () {},
              ),
            );
          }),
    );
  }
}
