import 'package:nilemap_frontend/Models/CategoryModel.dart';
import 'package:nilemap_frontend/Models/LocationModel.dart';

class Room {
  int room_num;
  String room_name;
  String desc;
  String floor;
  Location location;
  int location_id;
  int category_id;
  Category category;
  Room(
      {this.room_num,
      this.room_name,
      this.desc,
      this.floor,
      this.location,
      this.category,
      this.category_id,
      this.location_id});

  Room.fromjson(Map<String, dynamic> map) {
    this.room_num = map['Room_no'];
    this.room_name = map['room_name'];
    this.desc = map['Desc'];
    this.floor = map['Floor'];
    //there is a light issue here
    if (!map.containsKey('location')) {
      this.location_id = map['location_id'];
      print(location_id);
    } else {
      this.location = Location.fromjson(map['location']);
      print(location.id);
    }

    //this.category = Category.fromjson(map['category']); for now
    this.category_id = map['category_id'];
  }

  toJson() {
    Map<String, dynamic> map = {};
    map['room_num'] = this.room_num;
    map['room_name'] = this.room_name;
    map['desc'] = this.desc;
    map['floor'] = this.floor;
    if (this.location == null) {
      map['location_id'] = this.location_id;
    } else {
      map['location_id'] = this.location.id;
    }

    if (this.category != null) {
      map['rcategory'] = this.category.id;
    } else {
      map['rcategory'] = null;
    }
    return map;
  }
}
