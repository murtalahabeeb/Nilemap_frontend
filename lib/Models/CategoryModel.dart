import 'package:nilemap_frontend/Models/LocationModel.dart';

import 'RoomModel.dart';

class Category {
  int id;
  String name;
  List<Location> locations;
  List<Room> rooms;
  Category(this.name, [this.id]);

  Category.fromjson(Map<String, dynamic> map) {
    if (map != null) {
      this.id = map['id'];
      this.name = map['Name'];
      this.locations = loc(map['location']);
      this.rooms = room(map['room']);
    }
  }

  Category.uncategorized(Map<String, dynamic> map) {
    if (map != null) {
      this.locations = loc(map['locations']);
      this.rooms = room(map['rooms']);
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
    Map<String, dynamic> map = {};
    map['id'] = this.id;
    map['name'] = this.name;
    return map;
  }
}
