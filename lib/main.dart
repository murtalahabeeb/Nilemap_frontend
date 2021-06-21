import 'package:flutter/material.dart';
import 'package:nilemap_frontend/Logic/Server_notifier.dart';
import 'package:nilemap_frontend/Logic/shared_preferences.dart';
import 'package:nilemap_frontend/Logic/visibility_notifier.dart';

import 'package:nilemap_frontend/Widgets/drawer.dart';
import 'package:provider/provider.dart';
import 'package:nilemap_frontend/constants.dart' as Constants;

import 'Screens/home.dart';
import 'package:nilemap_frontend/Logic/backend_requests.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserPreferences().init();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => ServerNotifier()),
    ChangeNotifierProvider(create: (_) => VisibilityNotifier()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureProvider<Map<String, dynamic>>(
      create: (context) {
        return HttpService().getAllLocation();
      },
      catchError: (context, error) {
        print(error);
      },
      initialData: {'categorized': [], 'uncategorized': null},
      child: MaterialApp(
        title: 'Nile Map',
        home: MyHomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage();
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  UserPreferences data;

  @override
  void initState() {
    super.initState();
    data = UserPreferences();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ServerNotifier notifier =
          Provider.of<ServerNotifier>(context, listen: false);

      if (data.id != 0) {
        if (notifier.admin == null) {
          notifier.user(data.id, data.token);
          // notifier.getLocation();
          // locatio\nNotifier.getUncategorized();
          // roomNotifier.getUncategorizedRooms();
        } else {
          // notifier.getLocation();
          // locationNotifier.getUncategorized();
          // roomNotifier.getUncategorizedRooms();
        }
      } else {
        // notifier.getLocation();
        // locationNotifier.getUncategorized();
        // roomNotifier.getUncategorizedRooms();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ServerNotifier>(
      builder: (_, notifier, __) {
        return Scaffold(
            drawer: MyDrawer(),
            appBar: AppBar(
              title: Text(
                'LOCATIONS',
                style: TextStyle(color: Constants.textColor),
              ),
              backgroundColor: Constants.secTextColor,
              iconTheme: IconThemeData(color: Constants.mainColor),
            ),
            body: notifier.loading
                ? Center(child: CircularProgressIndicator())
                : Home());
      },
    );
  }
}
