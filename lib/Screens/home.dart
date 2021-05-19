import 'package:flutter/material.dart';
import 'package:nilemap_frontend/Logic/Location_notifier.dart';
import 'package:nilemap_frontend/Widgets/EntryItem.dart';
import 'package:nilemap_frontend/main.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LocationNotifier>(
      builder: (_, notifier, __) => ListView.builder(
          itemCount: notifier.locList.length,
          itemBuilder: (context, index) {
            return ExpansionTileItems(notifier.locList[index]);
          }),
    );
  }
}
