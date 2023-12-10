import 'package:wh/all.dart';

class AsyncBody extends StatefulWidget {
  const AsyncBody(
      {super.key,
      this.appBar,
      this.loading = false,
      required this.child,
      this.floatingActionButton,
      this.floatingActionButtonLocation});
  final Widget child;
  final bool loading;
  final PreferredSizeWidget? appBar;
  final FloatingActionButton? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  @override
  State<AsyncBody> createState() => _AsyncBodyState();
}

class _AsyncBodyState extends State<AsyncBody> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: widget.appBar,
          floatingActionButton: widget.floatingActionButton,
          floatingActionButtonLocation: widget.floatingActionButtonLocation,
          body: Stack(
            children: [
              widget.child,
              widget.loading
                  ? Container(
                      width: size.width,
                      height: size.height,
                      color: Colors.black12,
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          width: size.width * .8,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const CircularProgressIndicator(),
                                Text(resPleaseWait),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container()
            ],
          ),
        ));
  }
}
