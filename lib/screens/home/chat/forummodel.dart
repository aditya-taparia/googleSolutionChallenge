class User {
  final int id;
  final String name;

  User({
    required this.id,
    required this.name,
  });
}

class Message {
  final User sender;
  final String time;
  final String text;
  final int numLiked;
  final bool isLiked;

  final String msg;

  Message({
    required this.sender,
    required this.time,
    required this.text,
    required this.numLiked,
    required this.msg,
    required this.isLiked,
  });
}

final User somsagar = User(
  id: 1,
  name: 'Somsagar',
);
List<Message> forum = [
  Message(
      sender: somsagar,
      time: '1/03/2022',
      text: 'Hey, how\'s it going? What did you do today?',
      numLiked: 3,
      isLiked: true,
      msg:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. In vestibulum ut metus sit amet scelerisque. Nam eget vestibulum tellus. Nullam sodales leo lectus, nec placerat dui fermentum et. Duis vel tortor nec tortor rutrum suscipit. Sed leo sem, varius et odio tempus, convallis pulvinar dolor'),
  Message(
      sender: somsagar,
      time: '1/03/2022',
      text: 'Hey, how\'s it going? What did you do today?',
      numLiked: 3,
      isLiked: true,
      msg:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. In vestibulum ut metus sit amet scelerisque. Nam eget vestibulum tellus. Nullam sodales leo lectus, nec placerat dui fermentum et. Duis vel tortor nec tortor rutrum suscipit. Sed leo sem, varius et odio tempus, convallis pulvinar dolor'),
  Message(
      sender: somsagar,
      time: '1/03/2022',
      text: 'Hey, how\'s it going? What did you do today?',
      numLiked: 3,
      isLiked: true,
      msg:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. In vestibulum ut metus sit amet scelerisque. Nam eget vestibulum tellus. Nullam sodales leo lectus, nec placerat dui fermentum et. Duis vel tortor nec tortor rutrum suscipit. Sed leo sem, varius et odio tempus, convallis pulvinar dolor'),
];
