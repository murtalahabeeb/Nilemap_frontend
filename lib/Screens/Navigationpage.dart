import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nilemap_frontend/Logic/Location_notifier.dart';
import 'package:nilemap_frontend/Logic/MapNotifier.dart';
import 'package:nilemap_frontend/Models/LocationModel.dart';
import 'package:nilemap_frontend/Models/RoomModel.dart';
import 'package:nilemap_frontend/Widgets/Map.dart';
import 'package:nilemap_frontend/Widgets/currentButton.dart';
import 'package:provider/provider.dart';

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
  Set<Marker> markers = {};
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    Marker startMarker = Marker(
      markerId: MarkerId(LatLng(
              widget.location == null
                  ? double.parse(widget.room.location.lat)
                  : double.parse(widget.location.lat),
              widget.location == null
                  ? double.parse(widget.room.location.long)
                  : double.parse(widget.location.long))
          .toString()),
      position: LatLng(
          widget.location == null
              ? double.parse(widget.room.location.lat)
              : double.parse(widget.location.lat),
          widget.location == null
              ? double.parse(widget.room.location.long)
              : double.parse(widget.location.long)),
      infoWindow: InfoWindow(
        title: widget.location == null
            ? widget.room.location.name
            : widget.location.name,
        snippet: LatLng(
                widget.location == null
                    ? double.parse(widget.room.location.lat)
                    : double.parse(widget.location.lat),
                widget.location == null
                    ? double.parse(widget.room.location.long)
                    : double.parse(widget.location.long))
            .toString(),
      ),
      icon: BitmapDescriptor.defaultMarker,
    );
    markers.add(startMarker);
    // Determining the screen width & height

    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => MapNotifier())],
      child: Container(
        height: height,
        width: width,
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              MapView(markers, widget.location),
              CurrentButton(),
              _buildTiles(width)
            ],
          ),
        ),
      ),
    );
  }

  void _showDesc() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
            child: Text(widget.room.floor + " floor, " + widget.room.desc,
                style: TextStyle(fontSize: 20.0)),
          );
        });
  }

  void _showRooms(LocationNotifier notifier) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            //padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 60.0),
            child: Consumer<LocationNotifier>(
              builder: (_, notifier, __) {
                return ListView.builder(
                    itemCount: notifier.roomList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                          title: Text(
                        notifier.roomList[index].room_name,
                        style: TextStyle(color: Colors.black, fontSize: 20.0),
                      ));
                    });
              },
            ),
          );
        });
  }

  Widget _buildTiles(width) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
            ),
            width: width * 0.9,
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    widget.location == null
                        ? widget.room.location.name
                        : widget.location.name,
                    style: TextStyle(fontSize: 20.0),
                  ),
                  widget.location == null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              widget.room.room_name,
                              style: TextStyle(fontSize: 15.0),
                            ),
                            Text(
                              'Room ${widget.room.room_num}',
                              style: TextStyle(fontSize: 15.0),
                            ),
                          ],
                        )
                      : Consumer<LocationNotifier>(builder: (_, notifier, __) {
                          return FlatButton(
                            onPressed: () {
                              notifier.getLocRoom(widget.location.id);
                              _showRooms(notifier);
                            },
                            child: Text(
                              'Rooms',
                              style:
                                  TextStyle(fontSize: 20.0, color: Colors.blue),
                            ),
                            color: Colors.transparent,
                          );
                        }),
                  widget.location == null
                      ? FlatButton(
                          onPressed: _showDesc,
                          child: Text(
                            'Description',
                            style:
                                TextStyle(fontSize: 20.0, color: Colors.blue),
                          ),
                          color: Colors.transparent,
                        )
                      : Container()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
