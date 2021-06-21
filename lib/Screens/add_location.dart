import 'package:flutter/material.dart';
import 'package:nilemap_frontend/Logic/Server_notifier.dart';
import 'package:nilemap_frontend/Logic/visibility_notifier.dart';
import 'package:nilemap_frontend/Models/CategoryModel.dart';
import 'package:nilemap_frontend/Models/LocationModel.dart';
import 'package:nilemap_frontend/Models/RoomModel.dart';
import 'package:nilemap_frontend/Screens/edit_delete_location.dart';
import 'package:nilemap_frontend/Widgets/drawer.dart';
import 'package:nilemap_frontend/Widgets/list_of_room_container.dart';
import 'package:nilemap_frontend/Widgets/multiForm.dart';
import 'package:nilemap_frontend/Widgets/rounded_button.dart';
import 'package:nilemap_frontend/Widgets/show_room.dart';
import 'package:provider/provider.dart';

import 'package:nilemap_frontend/Logic/backend_requests.dart';

class AddLocation extends StatefulWidget {
  final Location location;
  AddLocation([this.location]);
  @override
  _AddLocationState createState() => _AddLocationState();
}

class _AddLocationState extends State<AddLocation> {
  var dropdownValue;
  List<Room> rooms;
  TextEditingController lat;
  TextEditingController long;
  TextEditingController name;
  final formKey = GlobalKey<FormState>();
  Category cat;
  @override
  void initState() {
    super.initState();
    lat = widget.location == null
        ? TextEditingController()
        : TextEditingController(text: widget.location.lat);
    long = widget.location == null
        ? TextEditingController()
        : TextEditingController(text: widget.location.long);
    name = widget.location == null
        ? TextEditingController()
        : TextEditingController(text: widget.location.name);
    dropdownValue = widget.location == null ? null : widget.location.categoryId;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ServerNotifier notifier =
          Provider.of<ServerNotifier>(context, listen: false);
      notifier.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //drawer: MyDrawer(),
      appBar: AppBar(
        elevation: 0.0,
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
              MaterialPageRoute(builder: (context) => DeleteEditScreen()),
            );
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.location == null
                      ? Container()
                      : FlatButton(
                          color: Colors.transparent,
                          onPressed: () {
                            _showRooms();
                          },
                          child: Text(
                            "Show rooms",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      controller: name,
                      decoration: InputDecoration(
                        labelText: 'Location Name',
                        icon: Icon(
                          Icons.business,
                          color: Colors.blue,
                          size: 35.0,
                        ),
                      ),
                      validator: (value) {
                        if (value.length < 1) {
                          return 'Cannot be empty';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      controller: lat,
                      decoration: InputDecoration(
                        labelText: 'Latitude',
                        icon: Icon(
                          Icons.add_location_alt_outlined,
                          color: Colors.blue,
                          size: 35.0,
                        ),
                      ),
                      validator: (value) {
                        if (value.length < 1) {
                          return 'Cannot be empty';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, top: 16.0, right: 16.0),
                    child: TextFormField(
                      controller: long,
                      decoration: InputDecoration(
                        labelText: 'Longitude',
                        icon: Icon(
                          Icons.add_location_alt_outlined,
                          color: Colors.blue,
                          size: 35.0,
                        ),
                      ),
                      validator: (value) {
                        if (value.length < 1) {
                          return 'Cannot be empty';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 50.0),
                    child: Consumer<ServerNotifier>(
                        builder: (_, notifier, __) => FlatButton(
                              onPressed: () async {
                                await notifier.autosetlatlng();
                                lat.text = notifier.lat;
                                long.text = notifier.long;
                              },
                              child: Text(
                                'Get location cordinates',
                                style: TextStyle(
                                    fontSize: 10.0, color: Colors.blue),
                              ),
                              color: Colors.transparent,
                            )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 50.0),
                    child: Consumer<ServerNotifier>(
                        builder: (_, serverNotifier, __) => Consumer<
                                Map<String, dynamic>>(
                            builder: (_, category, __) => DropdownButton<int>(
                                  value: dropdownValue,
                                  hint: Text("Select Category"),
                                  icon: const Icon(Icons.arrow_downward),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: const TextStyle(color: Colors.black),
                                  underline: Container(
                                    height: 2,
                                    color: Colors.blue,
                                  ),
                                  onChanged: (newValue) {
                                    cat = _getCategory(
                                        category['categorized'], newValue);
                                    serverNotifier.setcategory(cat);
                                    dropdownValue = newValue;
                                  },
                                  items: category['categorized']
                                      .map<DropdownMenuItem<int>>((value) {
                                    return DropdownMenuItem<int>(
                                      value: value.id,
                                      child: Text(value.name),
                                    );
                                  }).toList(),
                                ))),
                  ),
                  widget.location == null
                      ? MultiFormBuilder(
                          action: "Add Location",
                        )
                      : MultiFormBuilder(
                          action: "Edit Location",
                        ),
                  widget.location == null
                      ? Consumer<ServerNotifier>(
                          builder: (_, notifier, __) =>
                              RoomListContainer(notifier.addedRooms))
                      : Consumer<ServerNotifier>(
                          builder: (_, notifier, __) =>
                              RoomListContainer(notifier.editionList)),
                  Consumer<VisibilityNotifier>(builder: (_, notifier, __) {
                    return Center(
                      child: Visibility(
                          visible: notifier.loading,
                          child: CircularProgressIndicator()),
                    );
                  }),
                  Center(
                    child: Consumer<Map<String, dynamic>>(
                        builder: (_, category, __) => Consumer<ServerNotifier>(
                                builder: (_, serverNotifier, __) {
                              return Consumer<VisibilityNotifier>(
                                  builder: (_, userNotifier, __) {
                                return RoundedButton(
                                  press: () async {
                                    final isValid =
                                        formKey.currentState.validate();
                                    if (isValid) {
                                      formKey.currentState.save();
                                      userNotifier.isloading();
                                      if (cat == null) {
                                        cat = _getCategory(
                                            category['categorized'],
                                            dropdownValue);
                                      }
                                      serverNotifier.setcategory(cat);
                                      serverNotifier.setNameLatLng(
                                          name.text, lat.text, long.text);
                                      widget.location == null
                                          ? await serverNotifier.savelocation()
                                          : await serverNotifier
                                              .editlocation(widget.location.id);

                                      userNotifier.isloading();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text('Success'),
                                        ),
                                      );
                                    }
                                  },
                                  text: widget.location == null
                                      ? "Add Location"
                                      : "Edit Location",
                                );
                              });
                            })),
                  )
                ],
              )),
        ),
      ),
    );
  }

  _getCategory(List<Category> cate, int dropdownValue) {
    Category category;
    try {
      category = cate.where((element) => element.id == dropdownValue).first;
    } catch (e) {
      category = null;
    }
    return category;

    // if (category != null) {
    //   return category;
    // } else {
    //   return null;
    // }
  }

  void _showRooms() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return FutureProvider<List<Room>>(
            create: (context) {
              return HttpService().getAllRoomsForALocation(widget.location.id);
            },
            initialData: null,
            child: Container(
              //padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 60.0),
              child: Consumer<List<Room>>(
                builder: (_, rooms, __) {
                  if (rooms == null) {
                    return Center(child: CircularProgressIndicator());
                  } else if (rooms.isEmpty) {
                    return Center(
                      child: Text("This location has no room"),
                    );
                  } else {
                    return ListView.builder(
                        itemCount: rooms.length,
                        itemBuilder: (context, index) {
                          return ShowRoom(
                            room: rooms[index],
                            type: "admin",
                          );
                        });
                  }
                },
              ),
            ),
          );
        });
  }
}
