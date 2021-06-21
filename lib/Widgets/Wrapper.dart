import 'package:flutter/material.dart';
import 'package:nilemap_frontend/Logic/Server_notifier.dart';
import 'package:nilemap_frontend/Screens/Admin_home.dart';
import 'package:nilemap_frontend/Screens/login_screen.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ServerNotifier>(builder: (_, value, __) {
      return value.admin == null ? LoginScreen() : AdminHome();
    });
  }
}

// Consumer<ServerNotifier>(builder: (_, notifier, __) {
//             return data.id == null
//                 ? RoundedButton(
//                     text: "LOGIN",
//                     press: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => LoginScreen()),
//                       );
//                     },
//                   )
//                 : RoundedButton(
//                     text: "LOGOUT",
//                     press: () {
//                       Navigator.pushReplacement(
//                         context,
//                         MaterialPageRoute(builder: (context) => AdminHome()),
//                       );
//                     },
//                   );
//           }),
//         ),
//         appBar: AppBar(),
//         body: Consumer<ServerNotifier>(builder: (_, notifier, __) {
//           if (notifier.categoryList.length == 0) {
//             notifier.getLocation();
//           }

//           return notifier.categoryList.isEmpty
//               ? Center(child: CircularProgressIndicator())
//               : Home();
//         })
