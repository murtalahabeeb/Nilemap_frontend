import 'package:nilemap_frontend/Models/CategoryModel.dart';

import 'RoomModel.dart';

class Location {
  int id;
  String name;
  String lat;
  String long;
  int categoryId; //for now
  Category category;

  List<Room> rooms;
  Location(
    this.name,
    this.lat,
    this.long, [
    this.category,
    this.rooms,
    this.id,
  ]);

  room(List<dynamic> rooms) {
    return rooms.map((e) {
      return Room(
          room_num: e['Room_no'],
          room_name: e['room_name'],
          desc: e['Desc'],
          floor: e['Floor'],
          category_id: e['category_id']);
    }).toList();
  }

  Location.fromjson(Map<String, dynamic> map) {
    this.id = map['Location_id'];
    this.name = map['Name'];
    this.lat = map['Latitude'];
    this.long = map['Longitude'];
    this.categoryId = map['category_id'];
    //this.category = Category.fromjson(map['category']);
    //this.rooms = room(map['room']);
  }

  toJson() {
    Map<String, dynamic> map = {};
    map['Location_id'] = this.id;
    map['lname'] = this.name;
    map['latitude'] = this.lat;
    map['longitude'] = this.long;
    map['rooms'] = this.rooms.map((e) => e.toJson()).toList();
    if (this.category != null) {
      map['category_id'] = this.category.id;
    }

    return map;
  }
}
