import '../all.dart';

class ChatBubble extends StatelessWidget {
  final Message message;
  final bool isMe;

  const ChatBubble({super.key, required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () async {
        await Clipboard.setData(ClipboardData(text: message.message));
        Fluttertoast.showToast(msg: resCopied);
      },
      child: Container(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
        margin: EdgeInsets.only(
          top: 4,
          // bottom: 10,
          left: isMe ? 80 : 10,
          right: isMe ? 10 : 80,
        ),
        decoration: BoxDecoration(
          color: isMe
              ? const Color.fromARGB(255, 197, 227, 241)
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: const Color.fromARGB(255, 163, 192, 206),
            style: BorderStyle.solid,
            width: 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment:
                  isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Text(
                  message.sender,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  timeAgo(message.sendTime),
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              message.message,
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
