import 'package:flutter/material.dart';
import 'package:nilemap_frontend/Logic/Server_notifier.dart';
import 'package:nilemap_frontend/Logic/visibility_notifier.dart';
import 'package:nilemap_frontend/Screens/Admin_home.dart';

import 'package:nilemap_frontend/Widgets/drawer.dart';
import 'package:provider/provider.dart';
import 'package:nilemap_frontend/constants.dart' as Constants;

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  TextEditingController check = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirm = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        backgroundColor: Constants.secTextColor,
        iconTheme: IconThemeData(color: Constants.mainColor),
      ),
      body: Center(
        child: Consumer<ServerNotifier>(builder: (_, value, __) {
          return Consumer<VisibilityNotifier>(builder: (_, notifier, __) {
            return Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                    visible: notifier.isvisbleCheck,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 20.0, bottom: 20.0),
                      child: TextFormField(
                        controller: check,
                        decoration: InputDecoration(
                            hintText: 'Enter current password',
                            icon: Icon(Icons.lock)),
                        validator: (value) {
                          if (value.length < 1) {
                            return 'cannot be empty';
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                  ),
                  Visibility(
                      visible: notifier.isvisiblepassword,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                                top: 20.0,
                                bottom: 20.0),
                            child: TextFormField(
                              controller: password,
                              decoration: InputDecoration(
                                  hintText: 'New password',
                                  icon: Icon(Icons.lock)),
                              validator: (value) {
                                if (value.length < 6) {
                                  return 'Password should be atleast 6 characters';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                                top: 20.0,
                                bottom: 20.0),
                            child: TextFormField(
                              controller: confirm,
                              decoration: InputDecoration(
                                  hintText: 'Confirm password',
                                  icon: Icon(Icons.lock)),
                              validator: (value) {
                                if (value != password.text) {
                                  return 'Has to match with the password';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ],
                      )),
                  Visibility(
                      visible: notifier.loading,
                      child: CircularProgressIndicator()),
                  Visibility(
                    visible: notifier.isvisbleCheck,
                    child: RaisedButton(
                      onPressed: () async {
                        final isValid = formKey.currentState.validate();
                        if (isValid) {
                          formKey.currentState.save();
                          notifier.isloading();
                          await value.checkpassword(check.text);
                          notifier.isloading();
                          if (value.mgs['message'] == "confirmed") {
                            notifier.isvisibleforcheck();
                            notifier.isvisibleforpassword();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(notifier.mgs['message']),
                              ),
                            );
                          }
                        }
                      },
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Confirm',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: notifier.isvisiblepassword,
                    child: RaisedButton(
                      onPressed: () async {
                        final isValid = formKey.currentState.validate();
                        if (isValid) {
                          formKey.currentState.save();
                          notifier.isloading();
                          await value.changepassword(
                              password.text, confirm.text);
                          notifier.isloading();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(notifier.mgs['message'])),
                          );
                          if (notifier.mgs['message'] == "success") {
                            notifier.isvisibleforpassword();
                            notifier.isvisibleforcheck();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdminHome()),
                            );
                          }
                        }
                      },
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Change password',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                      visible: notifier.isvisiblepassword,
                      child: FlatButton(
                        onPressed: () {
                          notifier.isvisibleforpassword();
                          notifier.isvisibleforcheck();
                        },
                        child: Text(
                          "back",
                          style: TextStyle(color: Colors.blue),
                        ),
                        color: Colors.transparent,
                      )),
                ],
              ),
            );
          });
        }),
      ),
    );
  }
}
