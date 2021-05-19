import 'package:nilemap_frontend/Models/CategoryModel.dart';

import 'RoomModel.dart';

class Location {
  int id;
  String name;
  String lat;
  String long;
  Category category;
  List<Room> rooms;
  Location(this.id, this.name, this.lat, this.long,
      [this.category, this.rooms]);

  room(List<dynamic> rooms) {
    return rooms.map((e) {
      return Room(e['room_num'], e['room_name'], e['desc'], e['floor']);
    }).toList();
  }

  Location.fromjson(Map<String, dynamic> map) {
    this.id = map['Location_id'];
    this.name = map['Name'];
    this.lat = map['Latitude'];
    this.long = map['Longitude'];
    //this.category = Category.fromjson(map['category']);
    //this.rooms = room(map['room']);
  }

  toJson() {
    Map<String, dynamic> map;
    map['Location_id'] = this.id;
    map['Name'] = this.name;
    map['Latitude'] = this.lat;
    map['Longitude'] = this.long;
    map['category_id'] = this.category.id;
    return map;
  }
}
