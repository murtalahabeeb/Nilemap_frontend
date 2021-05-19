import 'package:nilemap_frontend/Models/CategoryModel.dart';
import 'package:nilemap_frontend/Models/LocationModel.dart';

class Room {
  int room_num;
  String room_name;
  String desc;
  String floor;
  Location location;
  Category category;
  Room(this.room_num, this.room_name, this.desc, this.floor,
      [this.location, this.category]);

  Room.fromjson(Map<String, dynamic> map) {
    this.room_num = map['Room_num'];
    this.room_name = map['room_name'];
    this.desc = map['Desc'];
    this.floor = map['Floor'];
    //there is a light issue here
    this.location = Location.fromjson(map['location']);
    //this.category = Category.fromjson(map['category']); for now
  }

  toJson() {
    Map<String, dynamic> map;
    map['Room_num'] = this.room_num;
    map['room_name'] = this.room_name;
    map['Desc'] = this.desc;
    map['Floor'] = this.floor;
    map['location_id'] = this.location.id;
    map['category'] = this.category.id;
    return map;
  }
}
