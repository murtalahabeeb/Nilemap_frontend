import 'package:flutter/material.dart';
import 'package:nilemap_frontend/Logic/Server_notifier.dart';
import 'package:nilemap_frontend/Logic/visibility_notifier.dart';
import 'package:nilemap_frontend/Models/CategoryModel.dart';
import 'package:nilemap_frontend/Screens/edit_delete_category.dart';
import 'package:nilemap_frontend/Widgets/drawer.dart';
import 'package:provider/provider.dart';

class AddOrEditCategory extends StatefulWidget {
  final Category category;
  AddOrEditCategory([this.category]);
  @override
  _AddOrEditCategoryState createState() => _AddOrEditCategoryState();
}

class _AddOrEditCategoryState extends State<AddOrEditCategory> {
  final formKey = GlobalKey<FormState>();
  TextEditingController categoryController;
  @override
  void initState() {
    super.initState();
    categoryController = widget.category == null
        ? TextEditingController()
        : TextEditingController(text: widget.category.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //elevation: 0.0,
        // title: Text(
        //   'Add New Location',
        //   style: TextStyle(color: Constants.textColor),
        // ),
        backgroundColor: Colors.grey[50],
        iconTheme: IconThemeData(color: Colors.blue),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => EditDeleteCategory()),
            );
          },
        ),
      ),
      body: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 20.0, bottom: 20.0),
              child: TextFormField(
                controller: categoryController,
                decoration: InputDecoration(
                    hintText: 'Category Name', icon: Icon(Icons.category)),
                validator: (value) {
                  if (value.length < 1) {
                    return 'Cannot be empty';
                  } else {
                    return null;
                  }
                },
              ),
            ),
            Consumer<VisibilityNotifier>(builder: (_, notifier, __) {
              return Center(
                child: Visibility(
                    visible: notifier.loading,
                    child: CircularProgressIndicator()),
              );
            }),
            Consumer<ServerNotifier>(builder: (_, notifier, __) {
              return Consumer<VisibilityNotifier>(
                  builder: (_, userNotifier, __) {
                return RaisedButton(
                  onPressed: () async {
                    final isValid = formKey.currentState.validate();
                    if (isValid) {
                      formKey.currentState.save();
                      userNotifier.isloading();
                      notifier.setName(categoryController.text);
                      widget.category == null
                          ? await notifier.addcategory()
                          : await notifier.editcategory(widget.category.id);
                      userNotifier.isloading();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Success'),
                        ),
                      );
                    }
                  },
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.category == null
                          ? 'Add category'.toUpperCase()
                          : 'Edit category'.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                );
              });
            }),
          ],
        ),
      ),
    );
  }
}
