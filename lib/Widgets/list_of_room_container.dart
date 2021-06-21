import 'package:flutter/material.dart';
import 'package:nilemap_frontend/Logic/Server_notifier.dart';
import 'package:nilemap_frontend/Logic/visibility_notifier.dart';
import 'package:nilemap_frontend/Models/RoomModel.dart';
import 'package:provider/provider.dart';

class RoomListContainer extends StatefulWidget {
  final List<Room> rooms;
  RoomListContainer(this.rooms);

  @override
  _RoomListContainerState createState() => _RoomListContainerState();
}

class _RoomListContainerState extends State<RoomListContainer> {
  List flags = [];
  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(maxHeight: 400),
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
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.rooms.length,
                itemBuilder: (context, index) {
                  flags.add(true);
                  var flag = flags[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent),
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 8.0, left: 8.0),
                          child: Text(
                            "${widget.rooms[index].room_num.toString()} - ${widget.rooms[index].room_name} - ${widget.rooms[index].floor} - ${widget.rooms[index].category == null ? "uncategorized" : widget.rooms[index].category.name}",
                            softWrap: true,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color:
                                    _color(widget.rooms, widget.rooms[index]),
                                fontSize: 12.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ),

                        Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                new Text(widget.rooms[index].desc,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: _color(
                                            widget.rooms, widget.rooms[index]),
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold),
                                    overflow:
                                        flag ? TextOverflow.ellipsis : null),
                                new InkWell(
                                    child: new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        new Text(
                                          widget.rooms[index].desc.length >= 30
                                              ? flag
                                                  ? "show more"
                                                  : "show less"
                                              : " ",
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 12.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    onTap: widget.rooms[index].desc.length >= 30
                                        ? () {
                                            setState(() {
                                              flags[index] = !flags[index];
                                            });
                                          }
                                        : null),
                              ],
                            )),
                        // action == "Adding"
                        //     ?
                        Consumer<ServerNotifier>(builder: (_, notifier, __) {
                          return FlatButton(
                            padding: EdgeInsets.all(0.0),
                            onPressed: () {
                              notifier.deleteRoomFromAddedRooms(
                                  widget.rooms[index]);
                            },
                            child: Text(
                              'Delete',
                              style:
                                  TextStyle(fontSize: 10.0, color: Colors.blue),
                            ),
                            color: Colors.transparent,
                          );
                        })
                        // : Row(
                        //     mainAxisAlignment:
                        //         MainAxisAlignment.spaceAround,
                        //     mainAxisSize: MainAxisSize.min,
                        //     children: [
                        //       FlatButton(
                        //         padding: EdgeInsets.all(0.0),
                        //         onPressed: () {},
                        //         child: Text(
                        //           'Edit',
                        //           style: TextStyle(
                        //               fontSize: 10.0, color: Colors.blue),
                        //         ),
                        //         color: Colors.transparent,
                        //       ),
                        //       FlatButton(
                        //         padding: EdgeInsets.all(0.0),
                        //         onPressed: () {},
                        //         child: Text(
                        //           'Delete',
                        //           style: TextStyle(
                        //               fontSize: 10.0, color: Colors.blue),
                        //         ),
                        //         color: Colors.transparent,
                        //       )
                        //     ],
                        //   )
                      ],
                    ),
                  );
                })));
  }

  Color _color(List<Room> rooms, Room room) {
    var len = rooms.where((e) => e.room_num == room.room_num).length;
    if (len > 1) {
      return Colors.red;
    } else {
      return Colors.black;
    }
  }

  bool showOrHide() {
    var flag = false;
  }
}
