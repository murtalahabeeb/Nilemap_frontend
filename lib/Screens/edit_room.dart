import 'package:flutter/material.dart';
import 'package:nilemap_frontend/Models/RoomModel.dart';
import 'package:nilemap_frontend/Widgets/multiForm.dart';

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
      appBar: AppBar(),
      body: Center(
          child: Container(
              width: 500,
              height: 500,
              child: MultiFormBuilder(editing_room: widget.room))),
    );
  }
}
