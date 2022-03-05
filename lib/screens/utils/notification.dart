import 'package:flutter/material.dart';

class notify extends StatefulWidget {
  const notify({Key? key}) : super(key: key);

  @override
  State<notify> createState() => _notifyState();
}

List<String> notifications = [
  "2000/- transferred from Kowsik",
  "your post was liked",
  "your service request has been approved"
];
List<int> notifications_day = [1, 5, 4];

List<int> notifications_type = [1, 0, 2];

class _notifyState extends State<notify> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inbox"),
      ),
      body: Container(
        child: ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: notifications_type[index] == 0
                    ? const Icon(
                        Icons.volunteer_activism,
                        color: Colors.pink,
                      )
                    : notifications_type[index] == 1
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
                  notifications_day[index].toString() + "D",
                  style: TextStyle(color: Colors.grey),
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.more_vert,
                  ),
                  onPressed: () {},
                ),
              );
            }),
      ),
    );
  }
}
