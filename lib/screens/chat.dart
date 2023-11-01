import '../all.dart';

List<Message> messages = [];

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final scroller = ScrollController();
  void _sendMessage() {
    if (_controller.text.trim().isNotEmpty) {
      hubConnection?.invoke("Chat", args: [_controller.text.trim()]);

      scroller.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _controller.clear();
    }
  }

  static void Function(void Function())? chatState;
  @override
  initState() {
    super.initState();
    chatState = setState;
  }

  static void addMessage(Message msg) {
    messages.add(msg);
    if (chatState != null) {
      chatState!(() {});
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
