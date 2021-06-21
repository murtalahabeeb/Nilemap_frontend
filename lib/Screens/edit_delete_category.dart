import 'package:flutter/material.dart';
import 'package:nilemap_frontend/Logic/Server_notifier.dart';
import 'package:nilemap_frontend/Logic/visibility_notifier.dart';
import 'package:nilemap_frontend/Screens/add_category.dart';
import 'package:nilemap_frontend/Widgets/drawer.dart';
import 'package:provider/provider.dart';
import 'package:nilemap_frontend/Logic/backend_requests.dart';
import 'package:nilemap_frontend/constants.dart' as Constants;

class EditDeleteCategory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        backgroundColor: Constants.secTextColor,
        iconTheme: IconThemeData(color: Constants.mainColor),
      ),
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          FutureProvider<Map<String, dynamic>>(
            create: (context) => HttpService().getAllLocation(),
            initialData: {'categorized': [], 'uncategorized': null},
            child: Consumer<Map<String, dynamic>>(
              builder: (_, category, __) {
                return Consumer<ServerNotifier>(builder: (_, value, __) {
                  if (!category['categorized'].isEmpty) {
                    value.setcatelist(category['categorized']);
                    return ListView.builder(
                        itemCount: value.categoryList.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(value.categoryList[index].name),
                            subtitle: Text(
                                "Category ID:${category['categorized'][index].id}"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AddOrEditCategory(
                                                    value.categoryList[index])),
                                      );
                                    }),
                                Consumer<VisibilityNotifier>(
                                    builder: (_, value2, __) {
                                  return IconButton(
                                      icon: Icon(Icons.delete_forever),
                                      onPressed: () async {
                                        value2.isloading();
                                        await value.deletecategory(
                                            value.categoryList[index]);
                                        value2.isloading();
                                        // category['categorized']
                                        //     .remove(category['categorized'][index]);

                                        //category.locations.remove(loc);
                                      });
                                })
                              ],
                            ),
                          );
                        });
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                });
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
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Constants.btnColor,
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AddOrEditCategory()),
            );
          },
        ),
      ),
    );
  }
}
