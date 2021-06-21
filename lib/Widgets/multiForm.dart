import 'package:flutter/material.dart';
import 'package:nilemap_frontend/Logic/Server_notifier.dart';
import 'package:nilemap_frontend/Logic/visibility_notifier.dart';
import 'package:nilemap_frontend/Models/CategoryModel.dart';
import 'package:nilemap_frontend/Models/LocationModel.dart';
import 'package:nilemap_frontend/Models/RoomModel.dart';
import 'package:provider/provider.dart';

class MultiFormBuilder extends StatefulWidget {
  final String action;
  final Room editing_room;
  MultiFormBuilder({this.action, this.editing_room});
  @override
  _MultiFormBuilderState createState() => _MultiFormBuilderState();
}

class _MultiFormBuilderState extends State<MultiFormBuilder> {
  TextEditingController roomName;
  TextEditingController roomNum;
  TextEditingController desc;
  TextEditingController floor;
  final formKey = GlobalKey<FormState>();
  Category cat;
  var dropdownValue;
  @override
  void initState() {
    super.initState();
    roomName = widget.editing_room == null
        ? TextEditingController()
        : TextEditingController(text: widget.editing_room.room_name);
    roomNum = widget.editing_room == null
        ? TextEditingController()
        : TextEditingController(text: widget.editing_room.room_num.toString());
    desc = widget.editing_room == null
        ? TextEditingController()
        : TextEditingController(text: widget.editing_room.desc);
    floor = widget.editing_room == null
        ? TextEditingController()
        : TextEditingController(text: widget.editing_room.floor);
    dropdownValue =
        widget.editing_room == null ? null : widget.editing_room.category_id;
  }

  @override
  void dispose() {
    super.dispose();
    roomName.dispose();
    roomNum.dispose();
    desc.dispose();
    floor.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Container(
        padding: EdgeInsets.all(28.0),
        width: 500.0,
        child: Card(
            color: Colors.white,
            margin: EdgeInsets.only(
              left: 5.0,
              right: 10.0,
            ),
            elevation: 0.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: roomNum,
                    decoration: InputDecoration(
                      labelText: 'Room Number',
                    ),
                    validator: (value) {
                      if (value.length < 1) {
                        return 'Cannot be empty';
                      } else if (int.tryParse(value) == null) {
                        return "Has to be a number";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: roomName,
                    decoration: InputDecoration(
                      labelText: 'Room Name',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: floor,
                    decoration: InputDecoration(
                      labelText: 'Floor',
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
                TextFormField(
                  controller: desc,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Description',
                  ),
                  validator: (value) {
                    if (value.length < 1) {
                      return 'Cannot be empty';
                    } else {
                      return null;
                    }
                  },
                ),
                Consumer<Map<String, dynamic>>(builder: (_, category, __) {
                  return Consumer<ServerNotifier>(
                      builder: (_, serverNotifier, __) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 0.0),
                      child: DropdownButton<int>(
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
                          cat = _getCategory(category['categorized'], newValue);

                          serverNotifier.setroomcategory(cat);

                          dropdownValue = newValue;
                          print(dropdownValue);
                        },
                        items: category['categorized']
                            .map<DropdownMenuItem<int>>((value) {
                          return DropdownMenuItem<int>(
                            value: value.id,
                            child: Text(value.name),
                          );
                        }).toList(),
                      ),
                    );
                  });
                }),
                Consumer<VisibilityNotifier>(builder: (_, notifier, __) {
                  return Center(
                    child: Visibility(
                        visible: notifier.room,
                        child: CircularProgressIndicator()),
                  );
                }),
                Consumer<ServerNotifier>(builder: (_, notifier, __) {
                  if (widget.action != null) {
                    return Align(
                        alignment: Alignment.topRight,
                        child: FlatButton(
                          onPressed: () async {
                            final isValid = formKey.currentState.validate();
                            if (isValid) {
                              Room room = Room(
                                  room_num: int.parse(roomNum.text),
                                  room_name: roomName.text,
                                  desc: desc.text,
                                  floor: floor.text,
                                  category: notifier.roomCategory,
                                  location: Location(
                                      notifier.locationname,
                                      notifier.lat,
                                      notifier.long,
                                      notifier.locationcategory));

                              widget.action == "Add Location"
                                  ? notifier.addroomToAddedRooms(room)
                                  : notifier.addroomToEditionRooms(room);
                              roomNum.clear();
                              roomName.clear();
                              desc.clear();
                              floor.clear();
                              dropdownValue = null;
                            }
                          },
                          child: Text(
                            'Add room',
                            style:
                                TextStyle(fontSize: 10.0, color: Colors.blue),
                          ),
                          color: Colors.transparent,
                        ));
                  } else {
                    return Consumer<Map<String, dynamic>>(
                        builder: (_, category, __) {
                      return Consumer<VisibilityNotifier>(
                          builder: (_, userNotifier, __) {
                        return RaisedButton(
                          onPressed: () async {
                            final isValid = formKey.currentState.validate();
                            if (isValid) {
                              userNotifier.isloadingforroom();
                              if (cat == null) {
                                cat = _getCategory(
                                    category['categorized'], dropdownValue);
                              }
                              notifier.setroomcategory(cat);

                              notifier.setNumNameDescFloorLocationCategory(
                                  roomNum: int.parse(roomNum.text),
                                  name: roomName.text,
                                  desc: desc.text,
                                  floor: floor.text,
                                  location: widget.editing_room.location,
                                  category: cat);

                              await notifier.editRoom(
                                  id: widget.editing_room.room_num,
                                  locId: widget.editing_room.location_id);
                              notifier.roomCategory = null;
                              userNotifier.isloadingforroom();
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
                              'Edit Room'.toUpperCase(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                        );
                      });
                    });
                  }
                }),
              ],
            )),
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
}
