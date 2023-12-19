import '../all.dart';

class ChatTextField extends StatefulWidget {
  const ChatTextField({
    super.key,
    required TextEditingController controller,
  }) : _controller = controller;

  final TextEditingController _controller;

  @override
  State<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextField(
        onChanged: (value) {
          setState(() {});
        },
        decoration: InputDecoration.collapsed(
            hintText: resTypeMessage,
            border: InputBorder.none,
            hintTextDirection: resTypeMessage.dirction),
        textDirection: widget._controller.text.dirction,
        maxLines: 1,
        controller: widget._controller,
      ),
    );
  }
}
