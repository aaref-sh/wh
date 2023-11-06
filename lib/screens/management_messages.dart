import '../all.dart';
import 'package:http/http.dart' as http;

class ManagementMessages extends StatefulWidget {
  const ManagementMessages({super.key});

  @override
  State<ManagementMessages> createState() => _ManagementMessagesState();
}

class _ManagementMessagesState extends State<ManagementMessages> {
  late Future<List<AdminMessage>> alerts;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    alerts = getAlerts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(resManagementMessages),
        actions: [
          IconButton(
              onPressed: () => reload(), icon: Icon(Icons.replay_outlined))
        ],
      ),
      body: FutureBuilder(
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            var alerts = snapshot.data;
            return Container(
                padding: const EdgeInsets.all(10),
                child: ListView.builder(
                    itemCount: alerts?.length,
                    itemBuilder: ((context, index) {
                      return ListTile(
                        onTap: () {
                          if (alerts[index].location.latitude == null) {
                            Fluttertoast.showToast(msg: resNoLocationProvided);
                            return;
                          }
                          viewSite(alerts[index]);
                        },
                        title: Text(alerts![index].text),
                      );
                    })));
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        future: alerts,
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
    alerts = getAlerts();
    await alerts;
    setState(() {});
  }
}

Future<List<AdminMessage>> getAlerts() async {
  var res = <AdminMessage>[];
  try {
    var response = await http.get(
      Uri.parse('$serverURI/API/Mobile/GetAllMessages'),
      headers: httpHeader(),
    );
    // Navigator.pop(context);
    if (response.statusCode == 200) {
      var map = jsonDecode(response.body) as Map<String, dynamic>;
      var msgs = map['messages'];

      msgs?.forEach((element) {
        res.add(AdminMessage.fromMap(element));
      });
    }
  } on Exception catch (e) {
    // TODO
  }
  return res;
}
