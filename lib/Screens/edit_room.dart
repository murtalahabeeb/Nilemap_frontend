import 'package:flutter/material.dart';
import 'package:nilemap_frontend/Models/RoomModel.dart';
import 'package:nilemap_frontend/Screens/edit_delete_location.dart';
import 'package:nilemap_frontend/Widgets/multiForm.dart';
import 'package:nilemap_frontend/constants.dart' as Constants;

class EditRoom extends StatefulWidget {
  final Room room;
  EditRoom(this.room);
  @override
  _EditRoomState createState() => _EditRoomState();
}

class _EditRoomState extends State<EditRoom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.secTextColor,
        iconTheme: IconThemeData(color: Constants.mainColor),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DeleteEditScreen()),
            );
          },
        ),
      ),
      body: Center(
          child: Container(
              width: 500,
              height: 500,
              child: MultiFormBuilder(editing_room: widget.room))),
    );
  }
}
