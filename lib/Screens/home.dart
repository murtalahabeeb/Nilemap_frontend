import 'package:flutter/material.dart';
import 'package:nilemap_frontend/Widgets/EntryItem.dart';
import 'package:nilemap_frontend/Widgets/user_loc_view.dart';
import 'package:nilemap_frontend/Widgets/user_room_view.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Consumer<Map<String, dynamic>>(
        builder: (_, category, __) {
          if (!category['categorized'].isEmpty &&
              category['uncategorized'] != null) {
            return Column(
              children: [
                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.all(0.0),
                    itemCount: category['categorized'].length,
                    itemBuilder: (context, index) {
                      return ExpansionTileItems(
                          category['categorized'][index], "user");
                    }),
                ExpansionTile(
                  title: Text("Uncategorized"),
                  children: [
                    Column(
                        mainAxisSize: MainAxisSize.min,
                        children: category['uncategorized']
                            .locations
                            .map<Widget>((loc) => UserLocationView(loc))
                            .toList()),
                    Column(
                        mainAxisSize: MainAxisSize.min,
                        children: category['uncategorized']
                            .rooms
                            .map<Widget>((room) => UserRoomView(room))
                            .toList()),
                  ],
                )
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
