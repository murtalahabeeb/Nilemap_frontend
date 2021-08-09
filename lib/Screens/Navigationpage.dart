import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nilemap_frontend/Logic/MapNotifier.dart';
import 'package:nilemap_frontend/Models/LocationModel.dart';
import 'package:nilemap_frontend/Models/RoomModel.dart';
import 'package:nilemap_frontend/Widgets/Map.dart';
import 'package:nilemap_frontend/Widgets/NavigationOptionsContainer.dart';
import 'package:nilemap_frontend/Widgets/OvalContainer.dart';
import 'package:nilemap_frontend/Widgets/currentButton.dart';
import 'package:nilemap_frontend/Widgets/show_room.dart';
import 'package:provider/provider.dart';
import 'package:nilemap_frontend/Logic/backend_requests.dart';
import 'package:nilemap_frontend/constants.dart' as Constants;

class Navigation extends StatefulWidget {
  const Navigation([this.location, this.room]);
  final Location location;
  final Room room;
  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  // Initial location of the Map view
  // CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));
  StreamSubscription<Position> positionStream;
  @override
  void dispose() {
    super.dispose();
    positionStream.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    // Determining the screen width & height

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MapNotifier()),
      ],
      child: Container(
        height: height,
        width: width,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              widget.location == null
                  ? "${widget.room.location.name}"
                  : "${widget.location.name}",
              style: TextStyle(color: Constants.textColor),
            ),
            backgroundColor: Constants.secTextColor,
            iconTheme: IconThemeData(color: Constants.mainColor),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                positionStream.cancel();
                Navigator.pop(context);
              },
            ),
          ),
          body: Stack(
            children: <Widget>[
              Consumer<MapNotifier>(builder: (_, notifier, __) {
                positionStream = notifier.positionStream;
                return MapView(widget.location ?? widget.room.location);
              }),
              Align(
                  alignment: Alignment.topCenter,
                  child: _locationDetails(width)),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: OvalContainer(_navigationOptions())),
              CurrentButton(),
            ],
          ),
        ),
      ),
    );
  }

  void _showDesc(Room room) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: ListTile(
                title: Text(room.floor + " floor - " + room.desc,
                    style: TextStyle(fontSize: 20.0)),
                subtitle: Text(room.floor)),
          );
        });
  }

  void _showRooms() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return FutureProvider<List<Room>>(
            create: (context) {
              return HttpService().getAllRoomsForALocation(
                  widget.location == null
                      ? widget.room.location.id
                      : widget.location.id);
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
                            type: "user",
                          );
                        });
                  }
                },
              ),
            ),
          );
        });
  }

  Widget _navigationOptions() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        NavigationOptionsButtons(),
      ],
    );
  }

  Widget _locationDetails(width) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
            child: Consumer<Map<String, dynamic>>(builder: (_, notifier, __) {
          return Consumer<MapNotifier>(builder: (_, value, __) {
            return widget.location == null
                ? _forRooms(value)
                : _forlocations(value);
          });
        })));
  }

  _forRooms(MapNotifier value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
            tileColor: Colors.white.withOpacity(0.9),
            title: Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Text("Room No: ${widget.room.room_num}",
                    style: TextStyle(fontSize: 20.0))),
            subtitle: Text('${value.placeDistance} km'),
            trailing: FlatButton(
              color: Colors.transparent,
              onPressed: () {
                _showDesc(widget.room);
              },
              child: Column(
                children: [
                  Icon(
                    Icons.description,
                    color: Colors.blue,
                  ),
                  Text(
                    "Show Description",
                    style: TextStyle(color: Colors.blue, fontSize: 10.0),
                  ),
                ],
              ),
            )),
        Divider(
          height: 1.0,
        ),
        ListTile(
          title: Text(
            "Room name: ${widget.room.room_name}",
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(widget.room.floor + " floor"),
        )
      ],
    );
  }

  _forlocations(MapNotifier value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          tileColor: Colors.white.withOpacity(0.9),
          title: Text('${value.placeDistance} km'),
          subtitle: GestureDetector(
            onTap: () {
              _showRooms();
            },
            child: Text(
              "Show rooms",
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ),
      ],
    );
  }
}
