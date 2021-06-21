import 'package:flutter/material.dart';
import 'package:nilemap_frontend/Logic/Server_notifier.dart';
import 'package:provider/provider.dart';
import 'package:nilemap_frontend/constants.dart' as Constants;

class Activities extends StatefulWidget {
  @override
  _ActivitiesState createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ServerNotifier notifier =
          Provider.of<ServerNotifier>(context, listen: false);

      notifier.getactivities();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Activity Logs',
            style: TextStyle(color: Constants.textColor),
          ),
          backgroundColor: Constants.secTextColor,
          iconTheme: IconThemeData(color: Colors.blue),
          bottom: TabBar(
            labelColor: Colors.blue,
            tabs: [
              Tab(
                icon: Icon(Icons.history),
                text: "Activities",
              ),
              Tab(
                icon: Icon(Icons.delete),
                text: "Deleted",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Consumer<ServerNotifier>(
              builder: (_, notifier, __) => ListView.builder(
                  itemCount: notifier.activities.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(notifier.activities[index].activityPerformed),
                      subtitle:
                          Text("Type: ${notifier.activities[index].type}"),
                    );
                  }),
            ),
            Consumer<ServerNotifier>(
              builder: (_, notifier, __) => ListView.builder(
                  itemCount: notifier.deleted.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        "Deleted: ${notifier.deleted[index].deleted}",
                        style: TextStyle(),
                        textAlign: TextAlign.justify,
                      ),
                      subtitle: Text('${notifier.deleted[index].id}'),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
