import '../all.dart';

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

  Future<void> loadMoreMessages() async {
    var adds = await DatabaseHelper.instance.getMessagePage(page: page++);
    morePages = adds.length == 100;
    adds.addAll(messages);
    setState(() {
      messages = adds;
    });
  }

  static void Function(void Function())? chatState;
  @override
  initState() {
    super.initState();
    chatState = setState;
    loadMoreMessages();
    scroller.addListener(() {
      if (morePages && scroller.position.maxScrollExtent == scroller.offset) {
        loadMoreMessages();
      }
    });
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
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: Colors.grey)
                // color: Colors.white,
                ),
            margin:
                const EdgeInsets.only(left: 10, right: 10, top: 2, bottom: 2),
            padding: EdgeInsets.only(left: 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration.collapsed(
                      hintText: resTypeMessage,
                      border: InputBorder.none,
                    ),
                    maxLines: 1,
                    controller: _controller,
                  ),
                ),
                const SizedBox(width: 5),
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
