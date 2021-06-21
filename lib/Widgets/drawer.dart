import 'package:flutter/material.dart';
import 'package:nilemap_frontend/Logic/shared_preferences.dart';
import 'package:nilemap_frontend/Screens/change_password.dart';
import 'package:nilemap_frontend/Screens/login_screen.dart';
import 'package:nilemap_frontend/Widgets/Wrapper.dart';
import 'package:nilemap_frontend/constants.dart' as Constants;
import 'package:nilemap_frontend/main.dart';
import 'package:provider/provider.dart';
import 'package:nilemap_frontend/Logic/Server_notifier.dart';

class MyDrawer extends StatelessWidget {
  final Color mainColor = Constants.mainColor;
  final Color secColor = Constants.secTextColor;
  final Color textColor = Constants.textColor;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Consumer<ServerNotifier>(builder: (_, notifier, __) {
        return ListView(
          children: <Widget>[
            _drawerHeader(context),
            _home(context),
            _dashboard(context),
            notifier.admin == null ? Container() : _changepassword(context),
            _logout(context),
          ],
        );
      }),
    );
  }

  Widget _drawerHeader(context) {
    return Consumer<ServerNotifier>(
      builder: (_, notifier, __) => notifier.admin == null
          ? DrawerHeader(
              decoration: BoxDecoration(
                color: secColor,
              ),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  'assets/nileImg.jpg',
                  fit: BoxFit.fitWidth,
                ),
              ),
            )
          : DrawerHeader(
              decoration: BoxDecoration(
                color: secColor,
              ),
              child: Container(
                child: Column(
                  children: <Widget>[
                    Material(
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Image.asset('assets/admin.png',
                            width: 80.0, height: 80.0),
                      ),
                    ),
                    Text(
                      notifier.admin.name,
                      style: TextStyle(
                          color: textColor,
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      notifier.admin.id.toString(),
                      style: TextStyle(color: mainColor, fontSize: 10.0),
                    ),
                    // Text(
                    //   'Admin',
                    //   styl: TextStyle(
                    //     color: mainColor,
                    //     fontSize: 10.0
                    //     ),
                    //   )
                  ],
                ),
              ),
            ),
    );
  }

  Widget _dashboard(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.admin_panel_settings,
        color: Colors.redAccent,
      ),
      title: Text('Admin Dashboard'),
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Wrapper()),
        );
      },
    );
  }

  Widget _changepassword(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.settings,
        color: Colors.redAccent,
      ),
      title: Text('Change Password'),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChangePassword()),
        );
      },
    );
  }

  Widget _home(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.home,
        color: Colors.redAccent,
      ),
      title: Text('Home page'),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyApp()),
        );
      },
    );
  }

  Widget _logout(BuildContext context) {
    return Consumer<ServerNotifier>(builder: (_, notifier, __) {
      return UserPreferences().id == 0
          ? ListTile(
              title: Text('Admin Login'),
              leading: Icon(
                Icons.login,
                color: Colors.redAccent,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Wrapper()),
                );
              },
            )
          : ListTile(
              title: Text('Logout'),
              leading: Icon(
                Icons.logout,
                color: Colors.redAccent,
              ),
              onTap: () async {
                await notifier.logout(UserPreferences().token);
                Navigator.pop(context);
              },
            );
    });
  }
}
