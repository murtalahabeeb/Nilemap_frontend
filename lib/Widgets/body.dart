import 'package:flutter/material.dart';
import 'package:nilemap_frontend/Logic/Server_notifier.dart';
import 'package:nilemap_frontend/Logic/shared_preferences.dart';
import 'package:nilemap_frontend/Logic/visibility_notifier.dart';
import 'package:nilemap_frontend/Screens/Admin_home.dart';
import 'package:nilemap_frontend/Widgets/Wrapper.dart';
import 'package:nilemap_frontend/Widgets/background.dart';
import 'package:nilemap_frontend/Widgets/rounded_button.dart';
import 'package:nilemap_frontend/main.dart';
import 'package:provider/provider.dart';

class Body extends StatelessWidget {
  Body({
    Key key,
  }) : super(key: key);

  TextEditingController userId = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "LOGIN",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            ClipOval(
              child: Image.asset(
                "assets/nileImg.jpg",
                height: size.height * 0.35,
              ),
            ),
            SizedBox(height: size.height * 0.03),
            Consumer<ServerNotifier>(
              builder: (_, notifier, __) => Padding(
                padding: EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 20.0, bottom: 20.0),
                child: TextFormField(
                  controller: userId,
                  decoration: InputDecoration(hintText: 'Admin ID'),
                ),
              ),
            ),
            Consumer<ServerNotifier>(
              builder: (_, notifier, __) => Padding(
                padding: EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 20.0, bottom: 20.0),
                child: Consumer<VisibilityNotifier>(builder: (_, value, __) {
                  return TextFormField(
                    controller: password,
                    obscureText: value.obscure,
                    decoration: InputDecoration(
                        hintText: 'Password',
                        suffixIcon: GestureDetector(
                            onTap: () {
                              value.setobscure();
                            },
                            child: Icon(Icons.remove_red_eye))),
                  );
                }),
              ),
            ),
            Consumer<VisibilityNotifier>(builder: (_, notifier, __) {
              return Center(
                child: Visibility(
                    visible: notifier.loading,
                    child: CircularProgressIndicator()),
              );
            }),
            Consumer<ServerNotifier>(
              builder: (_, notifier, __) =>
                  Consumer<VisibilityNotifier>(builder: (_, userNotifier, __) {
                return RoundedButton(
                  text: "LOGIN",
                  press: () async {
                    notifier.userid = int.parse(userId.text);
                    notifier.password = password.text;
                    userNotifier.isloading();
                    //notifier.setlogindetails(id, password)
                    await notifier.login();
                    userNotifier.isloading();
                    if (notifier.mgs != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(notifier.mgs),
                        ),
                      );
                      notifier.resetlogindetails();
                    } else {
                      UserPreferences data = UserPreferences();
                      await data.setId(notifier.admin.id);
                      await data.setToken(notifier.admin.rememberToken);
                      notifier.resetlogindetails();
                      userNotifier.obscure = true;

                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => Wrapper()),
                      // );
                    }
                  },
                );
              }),
            ),
            FlatButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                );
              },
              child: Text(
                "Home Page",
                style: TextStyle(color: Colors.blue),
              ),
              color: Colors.transparent,
            )
          ],
        ),
      ),
    );
  }
}
