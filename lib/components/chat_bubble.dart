import '../all.dart';

class ChatBubble extends StatelessWidget {
  final Message message;
  final bool isMe;

  const ChatBubble({super.key, required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      margin: EdgeInsets.only(
        top: 8,
        // bottom: 10,
        left: isMe ? 80 : 10,
        right: isMe ? 10 : 80,
      ),
      decoration: BoxDecoration(
        color: isMe ? Colors.lightBlue[100] : Colors.grey[200],
        borderRadius: BorderRadius.circular(15),
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
    );
  }
}
