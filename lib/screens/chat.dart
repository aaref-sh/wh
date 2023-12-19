import 'dart:ui';
import '../all.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final scroller = ScrollController();
  bool scrollDownButtonVisible = false;
  int page = 1;
  void _sendMessage() {
    if (_controller.text.trim().isNotEmpty) {
      var msg = IsolateMessage(
          IsolateMessages.chatMessage.index, _controller.text.trim());
      IsolateNameServer.lookupPortByName(backgroundIsolate)?.send(msg.toJson());
      _controller.clear();
    }
  }

  Future<void> loadMoreMessages() async {
    var adds = await DatabaseHelper.instance.getMessagePage(page: page++);
    morePages = adds.length == chatPageSize;
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
    messages.clear();
    loadMoreMessages();
    scroller.addListener(() {
      if (morePages && scroller.position.maxScrollExtent == scroller.offset) {
        loadMoreMessages();
      }
      showScrollDown(scroller.position.minScrollExtent != scroller.offset);
    });
  }

  @override
  void dispose() {
    super.dispose();
    messages.clear();
  }

  static void addMessage(Message msg) {
    messages.add(msg);
    if (chatState != null) chatState!(() {});
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var length = messages.length;
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text(resChatTapLabel),
          ),
          body: Stack(
            children: [
              Image.asset(
                'assets/Splash.png',
                fit: BoxFit.fitWidth,
                width: size.width,
                height: size.height,
                opacity: const AlwaysStoppedAnimation(0.04),
              ),
              Column(
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
                        border: Border.all(
                            color: const Color.fromARGB(255, 173, 173, 173))
                        // color: Colors.white,
                        ),
                    margin: const EdgeInsets.only(
                        left: 10, right: 10, top: 2, bottom: 2),
                    padding: const EdgeInsets.only(right: 10),
                    child: Row(
                      children: [
                        ChatTextField(controller: _controller),
                        const SizedBox(width: 5),
                        IconButton(
                            icon: const Icon(Icons.send),
                            onPressed: _sendMessage),
                      ],
                    ),
                  ),
                ],
              ),
              AnimatedPositioned(
                  bottom: 50,
                  left: scrollDownButtonVisible ? 10 : -50,
                  duration: const Duration(milliseconds: 150),
                  child: IconButton(
                    icon: Icon(
                      Icons.expand_circle_down_outlined,
                      color: appColor(),
                      size: 35,
                    ),
                    onPressed: () {
                      scroller.animateTo(0,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeIn);
                      // scrollDownButtonVisible = false;
                    },
                  )),
            ],
          ),
        ));
  }

  void showScrollDown(bool val) {
    if (val != scrollDownButtonVisible) {
      setState(() => scrollDownButtonVisible = val);
    }
  }
}
