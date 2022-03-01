import 'package:flutter/material.dart';
import 'package:googlesolutionchallenge/screens/home/Screens/individualchat.dart';
import 'package:googlesolutionchallenge/screens/home/Screens/sample.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: ListView.builder(
          itemCount: chats.length,
          itemBuilder: (BuildContext context, int index) {
            final chat = chats[index];
            return GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => IndividualChat(user: chat.sender))),
              child: Container(
                decoration: BoxDecoration(
                    color: chat.unread
                        ? Color.fromRGBO(66, 103, 178, 0.29)
                        : Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20))),
                margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                padding: EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage(chat.sender.imageUrl),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              chat.sender.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Text(
                                chat.text,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    TextStyle(fontSize: 15, color: Colors.grey),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          chat.time,
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        chat.unread
                            ? Container(
                                width: 40,
                                height: 20,
                                decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.circular(30)),
                                alignment: Alignment.center,
                                child: Text(
                                  'NEW',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            : SizedBox.shrink(),
                      ],
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
