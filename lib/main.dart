import 'package:flutter/material.dart';
import 'package:nilemap_frontend/Logic/Location_notifier.dart';
import 'package:provider/provider.dart';

import 'Screens/home.dart';

void main() {
  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => LocationNotifier())],
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    //loc.getLocation();

    return Scaffold(
        drawer: Drawer(),
        appBar: AppBar(),
        body: Consumer<LocationNotifier>(builder: (_, notifier, __) {
          if (notifier.locList.length == 0) {
            notifier.getLocation();
          }

          return notifier.locList.isEmpty
              ? Center(child: CircularProgressIndicator())
              : Home();
        }));
  }
}
