import 'package:flutter/material.dart';
import 'package:nilemap_frontend/Logic/Server_notifier.dart';
import 'package:nilemap_frontend/Logic/visibility_notifier.dart';
import 'package:nilemap_frontend/Screens/add_location.dart';
import 'package:nilemap_frontend/Widgets/EntryItem.dart';
import 'package:nilemap_frontend/Widgets/admin_loc_view.dart';
import 'package:nilemap_frontend/Widgets/admin_room_view.dart';
import 'package:nilemap_frontend/Widgets/drawer.dart';
import 'package:provider/provider.dart';
import 'package:nilemap_frontend/Logic/backend_requests.dart';
import 'package:nilemap_frontend/constants.dart' as Constants;

class DeleteEditScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureProvider<Map<String, dynamic>>(
      create: (context) {
        return HttpService().getAllLocation();
      },
      initialData: {'categorized': [], 'uncategorized': null},
      child: Scaffold(
        drawer: MyDrawer(),
        appBar: AppBar(
          backgroundColor: Constants.secTextColor,
          iconTheme: IconThemeData(color: Constants.mainColor),
        ),
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Consumer<Map<String, dynamic>>(
                builder: (_, category, __) {
                  return Column(
                    children: [
                      Consumer<ServerNotifier>(
                        builder: (_, value, __) {
                          if (!category['categorized'].isEmpty &&
                              category['uncategorized'] != null) {
                            value.setcatelist(category['categorized']);
                            value.setuncate(category['uncategorized']);
                            return Column(
                              children: [
                                ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.all(0.0),
                                    itemCount: value.categoryList
                                        .length, //category['categorized'].length,
                                    itemBuilder: (context, index) {
                                      return ExpansionTileItems(
                                          value.categoryList[
                                              index] /*category['categorized'][index]*/,
                                          "admin");
                                    }),
                                ExpansionTile(
                                  title: Text("Uncategorized"),
                                  children: [
                                    Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: //category['uncategorized']
                                            value.uncategorized.locations
                                                .map<Widget>((loc) =>
                                                    AdminLocationView(loc))
                                                .toList()),
                                    Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: //category['uncategorized']
                                            value.uncategorized.rooms
                                                .map<Widget>((room) =>
                                                    AdminRoomView(room))
                                                .toList()),
                                  ],
                                ),
                              ],
                            );
                          } else {
                            return Center(child: CircularProgressIndicator());
                          }
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
            Consumer<VisibilityNotifier>(builder: (_, value, __) {
              return Visibility(
                visible: value.loading,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.white.withOpacity(0.7),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            }),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add_location_alt_outlined),
          backgroundColor: Constants.btnColor,
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AddLocation(),
              ),
            );
          },
        ),
      ),
    );
  }
}
