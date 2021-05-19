import 'package:nilemap_frontend/Models/LocationModel.dart';

import 'RoomModel.dart';

class Category {
  int id;
  String name;
  List<Location> locations;
  List<Room> rooms;
  Category(this.id, this.name);

  Category.fromjson(Map<String, dynamic> map) {
    if (map != null) {
      this.id = map['id'];
      this.name = map['Name'];
      this.locations = loc(map['location']);
      this.rooms = room(map['room']);
    }
  }

  loc(List<dynamic> locations) {
    return locations.map((e) {
      return Location.fromjson(e);
    }).toList();
  }

  room(List<dynamic> rooms) {
    return rooms.map((e) {
      return Room.fromjson(e);
    }).toList();
  }

  toJson() {
    Map<String, dynamic> map;
    map['id'] = this.id;
    map['Name'] = this.name;
    return map;
  }
}
