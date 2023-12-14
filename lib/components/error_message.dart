import '../all.dart';

void showErrorMessage(BuildContext context, String message,
    {bool loading = false}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(
              20.0,
            ),
          ),
        ),
        contentPadding: const EdgeInsets.only(top: 10.0),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            loading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Text(message)),
            ),
            loading
                ? Container()
                : Container(
                    height: 60,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("موافق"),
                    ),
                  ),
          ],
        ),
      );
    },
  );
}
