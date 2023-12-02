import '../all.dart';
import 'package:http/http.dart' as http;

class ManagementMessages extends StatefulWidget {
  const ManagementMessages({super.key});

  @override
  State<ManagementMessages> createState() => _ManagementMessagesState();
}

class _ManagementMessagesState extends State<ManagementMessages> {
  var alerts = <AdminMessage>[];
  var scroller = ScrollController();
  var moreAlerts = false;
  int pageNumber = 0;
  bool loading = false;
  @override
  void initState() {
    super.initState();
    loadMoreAlerts();
    scroller.addListener(() {
      if (moreAlerts && scroller.position.maxScrollExtent == scroller.offset) {
        loadMoreAlerts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AsyncBody(
      loading: loading,
      child: Scaffold(
        appBar: AppBar(
          title: Text(resManagementMessages),
          actions: [
            IconButton(
                onPressed: () => reload(),
                icon: const Icon(Icons.replay_outlined))
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: ListView.builder(
            controller: scroller,
            itemCount: alerts.length,
            itemBuilder: ((context, index) {
              return ListTile(
                onTap: () {
                  if (alerts[index].location.latitude == null) {
                    Fluttertoast.showToast(msg: resNoLocationProvided);
                    return;
                  }
                  viewSite(alerts[index]);
                },
                title: Text(alerts[index].text),
              );
            }),
          ),
        ),
      ),
    );
  }

  viewSite(AdminMessage alert) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MapViewer(location: alert.location)),
    );
  }

  reload() async {
    setState(() => loading = true);
    try {
      await getAdminMessagesFromServer();
    } catch (e) {
      print(e);
    }
    setState(() => loading = false);
  }

  Future<void> loadMoreAlerts() async {
    setState(() => loading = true);
    var lst =
        await DatabaseHelper.instance.getAdminMessagesPage(page: ++pageNumber);
    alerts.addAll(lst);
    if (alerts.isEmpty) reload();
    moreAlerts = lst.length & messagesPageSize != 0;
    setState(() => loading = false);
  }

  Future<void> getAdminMessagesFromServer() async {
    try {
      var actionName = await DatabaseHelper.instance.isAdminMessagesEmpty()
          ? "GetAllMessages"
          : "GetPendingMessages";
      var response = await http.get(
        Uri.parse('$serverURI/API/Mobile/$actionName'),
        headers: httpHeader(),
      );
      // Navigator.pop(context);
      if (response.statusCode == 200) {
        var map = jsonDecode(response.body) as Map<String, dynamic>;
        var msgs = map['messages'];
        msgs?.forEach((element) {
          try {
            var alert = AdminMessage.fromMap(element);
            alerts.insert(0, alert);
            DatabaseHelper.instance.insertAdminMessage(alert);
          } catch (e) {}
        });
      }
      handleResponseError(context, response);
    } catch (e) {
      print(e);
    }
  }
}
