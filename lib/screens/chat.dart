import '../all.dart';

List<Message> messages = [
  Message(
      'فادي', 'مرحبا', DateTime.now().subtract(const Duration(minutes: 10))),
  Message(
      'احمد', 'مرحبا 2', DateTime.now().subtract(const Duration(minutes: 8))),
  Message(
      'خالد', 'مرحبا 3.', DateTime.now().subtract(const Duration(minutes: 5))),
];

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final scroller = ScrollController();
  void _sendMessage() {
    if (_controller.text.trim().isNotEmpty) {
      setState(() {
        messages
            .add(Message(username!, _controller.text.trim(), DateTime.now()));
      });
      scroller.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    var length = messages.length;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(resChatTapLabel),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: length,
              reverse: true,
              controller: scroller,
              itemBuilder: (context, index) {
                return ChatBubble(
                  message: messages[length - 1 - index],
                  isMe: messages[length - 1 - index].sender == username,
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: 4,
                    minLines: 1,
                    maxLength: 100,
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: resTypeMessage,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                    icon: const Icon(Icons.send), onPressed: _sendMessage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
