import 'package:flutter/material.dart';
import 'package:googlesolutionchallenge/screens/home/chat/sample.dart';

class IndividualChat extends StatefulWidget {
  const IndividualChat({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  _IndividualChatState createState() => _IndividualChatState();
}

class _IndividualChatState extends State<IndividualChat> {
  buildMessage(Message message, bool isUser) {
    return Container(
      margin: isUser
          ? const EdgeInsets.only(top: 10, bottom: 8, left: 80)
          : const EdgeInsets.only(top: 10, bottom: 8, right: 80),
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
      decoration: BoxDecoration(
        color: isUser
            ? const Color.fromRGBO(66, 103, 178, 1)
            : const Color.fromARGB(255, 235, 232, 232),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            message.text,
            style: TextStyle(color: isUser ? Colors.white : Colors.black),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              message.time,
              style: TextStyle(
                  color: !isUser ? Colors.grey : Colors.white, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  buildMessageComposer() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      height: 70,
      color: Colors.white,
      child: Row(children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.photo),
          iconSize: 30,
          color: Theme.of(context).primaryColor,
        ),
        Expanded(
            child: TextField(
          textCapitalization: TextCapitalization.sentences,
          onChanged: (value) {},
          decoration: const InputDecoration.collapsed(
            hintText: 'Send a message',
          ),
        )),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.send),
          iconSize: 30,
          color: Theme.of(context).primaryColor,
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(66, 103, 178, 1),
      appBar: AppBar(
        title: Text(widget.user.name),
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: (() => FocusScope.of(context).unfocus()),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  child: ListView.builder(
                      reverse: true,
                      padding: const EdgeInsets.only(top: 15),
                      itemCount: messages.length,
                      itemBuilder: (BuildContext context, int index) {
                        final Message message = messages[index];
                        final bool isUser = message.sender.id == currentUser.id;
                        return buildMessage(message, isUser);
                      }),
                ),
              ),
            ),
            buildMessageComposer(),
          ],
        ),
      ),
    );
  }
}
