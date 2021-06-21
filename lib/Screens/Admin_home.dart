import 'package:flutter/material.dart';

import 'package:nilemap_frontend/Logic/shared_preferences.dart';
import 'package:nilemap_frontend/Screens/activities.dart';
import 'package:nilemap_frontend/Screens/edit_delete_category.dart';
import 'package:nilemap_frontend/Screens/edit_delete_location.dart';

import 'package:nilemap_frontend/Widgets/drawer.dart';
import 'package:nilemap_frontend/constants.dart' as Constants;

class AdminHome extends StatelessWidget {
  final UserPreferences data = UserPreferences();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MyDrawer(),
        appBar: AppBar(
          title: Text(
            'Dashboard',
            style: TextStyle(color: Constants.textColor),
          ),
          backgroundColor: Constants.secTextColor,
          iconTheme: IconThemeData(color: Constants.mainColor),
        ),
        body: GridView.count(
          crossAxisCount: 2,
          children: <Widget>[
            // Card 2

            //Card 3
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DeleteEditScreen()),
                );
              },
              child: Card(
                //margin: EdgeInsets.only(left: 40.0, top: 40.0, right: 40.0, bottom: 20.0),
                color: Constants.card3,
                margin: EdgeInsets.only(
                    left: 10.0, right: 5.0, top: 10.0, bottom: 20.0),
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                child: Align(
                    alignment: Alignment.center,
                    // child: ListTile(
                    //   leading: Icon(Icons.check_circle, size: 50.0, color: card3),
                    //   title: Text(
                    //     'Total Approved Products',
                    //     style: TextStyle(color: textColor, fontSize: 30.0),
                    //     textAlign: TextAlign.center,
                    //   ),
                    //   subtitle: Text(
                    //     dashboardModel.totalApprovedProduct.toString(),
                    //     style: TextStyle(color: textColor, fontSize: 30.0),
                    //     textAlign: TextAlign.center,
                    //   ),
                    // ),
                    // child: IconButton(
                    //   onPressed: (){
                    //     getAlert(dashboardModel.totalApprovedProduct.toString(), 'Total Approved Products');
                    //   },
                    //   icon:Icon(Icons.check_circle, size: 50.0, color: card3)
                    // ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 8,
                          child: Padding(
                            padding: EdgeInsets.only(top: 30.0),
                            child: Icon(Icons.location_on_outlined,
                                size: 30.0, color: Colors.white),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Manage Locations',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    )),
              ),
            ),
            //Card 4

            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditDeleteCategory()),
                );
              },
              child: Card(
                //   margin: EdgeInsets.only(left: 40.0, top: 40.0, right: 40.0, bottom: 10.0),
                margin: EdgeInsets.only(
                    left: 5.0, right: 10.0, top: 10.0, bottom: 20.0),
                color: Constants.card4,
                elevation: 10.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                child: Align(
                    alignment: Alignment.center,
                    // child: ListTile(
                    //   leading: Icon(Icons.warning, size: 50.0, color: card4),
                    //   title: Text(
                    //     'Total Pending Products',
                    //     style: TextStyle(color: textColor, fontSize: 30.0),
                    //     textAlign: TextAlign.center,
                    //   ),
                    //   subtitle: Text(
                    //     dashboardModel.totalPendingProduct.toString(),
                    //     style: TextStyle(color: textColor, fontSize: 30.0),
                    //     textAlign: TextAlign.center,
                    //   ),
                    // ),
                    // child: IconButton(
                    //   onPressed: (){
                    //     getAlert(dashboardModel.totalPendingProduct.toString(), 'Total Pending Products');
                    //   },
                    //   icon:Center(child:Icon(Icons.warning, size: 50.0, color: Colors.white))
                    // ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                            flex: 8,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 30.0),
                              child: Icon(Icons.category_outlined,
                                  size: 30.0, color: Colors.white),
                            )),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Manage Categories',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    )),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Activities()),
                );
              },
              child: Card(
                  color: Constants.card1,
                  margin: EdgeInsets.only(
                      left: 10.0, right: 5.0, top: 20.0, bottom: 20.0),
                  elevation: 10.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  child: Align(
                    alignment: Alignment.center,
                    // child: ListTile(
                    //   leading: Icon(Icons.add_shopping_cart, size: 30.0, color: card1),
                    //   title: Text(
                    //     'Total Product Count',
                    //     style: TextStyle(color: textColor, fontSize: 14.0),
                    //     textAlign: TextAlign.center,
                    //   ),
                    //   subtitle: Text(
                    //     dashboardModel.totalProduct.toString(),
                    //     style: TextStyle(color: textColor, fontSize: 14.0),
                    //     textAlign: TextAlign.center,
                    //   ),
                    // ),
                    // child: IconButton(
                    //   onPressed: (){
                    //     getAlert(dashboardModel.totalProduct.toString(), 'Total Product Count');
                    //   },
                    //   icon: Icon(Icons.add_shopping_cart, size: 50.0, color: card1)
                    // )
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 8,
                          child: Padding(
                            padding: EdgeInsets.only(top: 30.0),
                            child: Icon(Icons.add,
                                size: 30.0, color: Colors.white),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "Show Activities",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          ],
        ));
  }
  // void getAlert(String alert, String title){
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text(title, textAlign: TextAlign.center,),
  //           content: Text(alert, textAlign: TextAlign.center),
  //           actions: <Widget>[
  //             Center(
  //               child: FlatButton(
  //                 child: Text('Ok'),
  //                 onPressed: () {
  //                    Navigator.popAndPushNamed(context, '/home');
  //                 },
  //               ),
  //             )
  //           ],
  //         );
  //       });
  // }

}
