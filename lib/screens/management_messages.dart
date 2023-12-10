import '../all.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

var newMessagesList = <int>[];

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
              var txt = alerts[index].text.replaceAll("\n", " ");
              return ExpansionTile(
                leading: Icon(
                    newMessagesList.contains(alerts[index].id)
                        ? Icons.mark_email_unread_outlined
                        : Icons.mark_email_read,
                    color: Colors.blue),
                title: Text(
                  txt.length > 50 ? '${txt.substring(0, 50)}...' : txt,
                ),
                subtitle: Text(
                    DateFormat.yMMMd().add_jm().format(alerts[index].sendTime)),
                trailing: alerts[index].location.latitude != null
                    ? IconButton(
                        icon: const Icon(Icons.location_on_rounded),
                        onPressed: () {
                          if (alerts[index].location.latitude == null) {
                            Fluttertoast.showToast(msg: resNoLocationProvided);
                            return;
                          }
                          viewSite(alerts[index]);
                          // do something when the location button is pressed
                        },
                      )
                    : null,
                expandedAlignment:
                    isRtl(txt) ? Alignment.bottomLeft : Alignment.bottomLeft,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      alerts[index].text,
                      style: const TextStyle(fontSize: 22),
                    ),
                  ),
                ],
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
      var res = await getAdminMessagesFromServer(context);
      if (res?.isNotEmpty ?? false) {
        alerts = [...res!, ...alerts];
      }
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
}

Future<List<AdminMessage>?> getAdminMessagesFromServer(context) async {
  try {
    var res = <AdminMessage>[];
    var response = await http.get(
      Uri.parse('$serverURI/API/Mobile/GetPendingMessages'),
      headers: httpHeader(),
    );
    // Navigator.pop(context);
    if (response.statusCode == 200) {
      var map = jsonDecode(response.body) as Map<String, dynamic>;
      var msgs = map['messages'];
      newMessagesList.clear();
      msgs?.forEach((element) {
        try {
          var alert = AdminMessage.fromMap(element);
          res.add(alert);
          newMessagesList.add(alert.id);
          DatabaseHelper.instance.insertAdminMessage(alert);
        } catch (e) {}
      });
    }
    handleResponseError(context, response);
    return res.reversed.toList();
  } catch (e) {
    print(e);
  }
  return null;
}
