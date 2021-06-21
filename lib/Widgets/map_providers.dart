import 'package:flutter/material.dart';
import 'package:nilemap_frontend/Models/LocationModel.dart';
import 'package:nilemap_frontend/Models/RoomModel.dart';
import 'package:nilemap_frontend/Screens/Navigationpage.dart';
import 'package:provider/provider.dart';
import 'package:nilemap_frontend/Logic/backend_requests.dart';

class GetRoomsProvider extends StatelessWidget {
  final Location location;
  final Room room;
  GetRoomsProvider({this.location, this.room});

  @override
  Widget build(BuildContext context) {
    return FutureProvider<List<Room>>(
      create: (context) {
        return HttpService().getAllRoomsForALocation(
            location == null ? room.location.id : location.id);
      },
      initialData: [],
      child: Navigation(location ?? room),
    );
  }
}
