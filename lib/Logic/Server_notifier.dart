import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:nilemap_frontend/Logic/shared_preferences.dart';
import 'package:nilemap_frontend/Models/ActivityModel.dart';
import 'package:nilemap_frontend/Models/AdminModel.dart';
import 'package:nilemap_frontend/Models/CategoryModel.dart';
import 'package:nilemap_frontend/Models/DeletedModel.dart';
import 'package:nilemap_frontend/Models/LocationModel.dart';
import 'package:nilemap_frontend/Models/RoomModel.dart';
import 'backend_requests.dart';

class ServerNotifier extends ChangeNotifier {
  int userid;
  String categoryname;
  int locationid;
  String locationname;
  String lat;
  String long;
  Category locationcategory;

  List<Location> locations = [];
  List<dynamic> _categoryList = [];
  List<Room> _roomList = [];
  List<Activity> _activities = [];
  List<Deleted> _deleted = [];
  List<Room> _addedRooms = [];
  List<Room> _editionList = [];
  Category uncategorized;

  Admin admin;
  String password;
  var mgs;
  HttpService req = HttpService();
  bool loading = false;

  UnmodifiableListView get categoryList => UnmodifiableListView(_categoryList);
  UnmodifiableListView<dynamic> get roomList => UnmodifiableListView(_roomList);
  UnmodifiableListView<dynamic> get activities =>
      UnmodifiableListView(_activities);
  UnmodifiableListView<dynamic> get deleted => UnmodifiableListView(_deleted);
  List<Room> get addedRooms => _addedRooms;
  List<Room> get editionList => _editionList;
  setloading() {
    loading = !loading;
    notifyListeners();
  }

  getLocRoom(int id) async {
    setloading();
    _roomList = await req.getAllRoomsForALocation(id);
    setloading();
  }

  deletelocationfromcategory(Location loc) {
    if (loc.categoryId == null) {
      uncategorized.locations.remove(loc);
      uncategorized.rooms
          .removeWhere((element) => element.location.id == loc.id);
    } else {
      for (var i = 0; i < categoryList.length; i++) {
        for (var j = 0; j < categoryList[i].locations.length; j++) {
          if (categoryList[i].locations[j].id == loc.id) {
            print(_categoryList[i].locations.remove(loc));
            categoryList.forEach((element) {
              element.rooms
                  .removeWhere((element) => element.location.id == loc.id);
            });
          }
        }
      }
    }
    notifyListeners();
  }

  deleteroomfromcategory(Room room) {
    if (room.category_id == null) {
      uncategorized.rooms.remove(room);
    } else {
      for (var i = 0; i < categoryList.length; i++) {
        for (var j = 0; j < categoryList[i].rooms.length; j++) {
          if (categoryList[i].rooms[j].room_num == room.room_num) {
            print(_categoryList[i].rooms.remove(room));
          }
        }
      }
    }
    notifyListeners();
  }

  deleteRoomFromAddedRooms(
    Room room,
  ) {
    addedRooms.remove(room);
    notifyListeners();
  }
  // deletecategory(Category category) {
  //   _categoryList.remove(category);
  //   notifyListeners();
  // }

  login() async {
    var data = await req.loginUser(userid, password);
    if (data == 404) {
      mgs = 'credentials do not match our records.';
    } else {
      admin = data;
    }
    userid = null;
    password = null;
    notifyListeners();
  }

  checkpassword(String password) async {
    mgs = await req.checkpassword(password);
    notifyListeners();
  }

  changepassword(String password, String confirm) async {
    mgs = await req.changepassword(password, confirm);
    notifyListeners();
  }

  setcatelist(List<Category> cate) {
    _categoryList = cate;
  }

  setuncate(Category cate) {
    uncategorized = cate;
  }

  user(user_id, token) async {
    try {
      admin = await req.getUser(user_id, token);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  setName(
    String name,
  ) {
    this.categoryname = name;
    notifyListeners();
  }

  addcategory() async {
    Category cate = Category(this.categoryname);
    print(cate.toJson());
    setloading();
    await req.addCategory(cate.toJson());
    this.categoryname = null;

    setloading();
  }

  editcategory(int id) async {
    Category cate = Category(this.categoryname, id);
    setloading();
    await req.editCategory(cate.toJson());
    this.categoryname = null;
    setloading();
  }

  deletecategory(Category cate) async {
    await req.deletecategory(cate);
    _categoryList.remove(cate);
    // or this :
    //await getLocation(); i think this is better
    notifyListeners();
  }

  logout(String token) async {
    String res = await req.logoutUser(token);
    if (res == "User Logged out") {
      admin = null;
      await UserPreferences().setId(0);
      await UserPreferences().setToken('');
    }
    notifyListeners();
  }

  getactivities() async {
    var data = await req.activiies();
    _activities = data['all_activities'];
    _deleted = data['deleted'];
    notifyListeners();
  }

  setNameLatLng(
    String name,
    String lat,
    String long,
  ) {
    this.locationname = name;
    this.lat = lat;
    this.long = long;
    notifyListeners();
  }

  setlogindetails(
    int id,
    String password,
  ) {
    this.userid = id;
    this.password = password;
    notifyListeners();
  }

  autosetlatlng() async {
    Position loc = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    lat = loc.latitude.toString();
    long = loc.longitude.toString();
    notifyListeners();
  }

  setcategory(Category category) {
    if (this.locationcategory != category) {
      this.locationcategory = category;
      notifyListeners();
    }
  }

  addroomToAddedRooms(
    Room room,
  ) {
    if (roomCategory != null) {
      room.category = roomCategory;
      addedRooms.add(room);
      roomCategory = null;
      notifyListeners();
    } else {
      addedRooms.add(room);
      notifyListeners();
    }
  }

  addroomToEditionRooms(
    Room room,
  ) {
    if (roomCategory != null) {
      room.category = roomCategory;
      editionList.add(room);
      roomCategory = null;
      notifyListeners();
    } else {
      editionList.add(room);
      notifyListeners();
    }
  }

  setroomcategory(Category category) {
    roomCategory = category;
    notifyListeners();
  }

  savelocation() async {
    Map<String, dynamic> map =
        Location(locationname, lat, long, locationcategory, addedRooms)
            .toJson();
    await req.saveNewLocation(map);
    reset();
    //notifyListeners();
  }

  editlocation(int id) async {
    this.locationid = id;

    Map<String, dynamic> map =
        Location(locationname, lat, long, locationcategory, editionList, id)
            .toJson();
    await req.editLocation(map);
    reset();
    //notifyListeners();
  }

  deleteLocation(Location location) async {
    await req.deleteLocation(location);
  }

  reset() {
    locationname = null;
    lat = null;
    long = null;
    locationcategory = null;
    _addedRooms.clear();
    _editionList.clear();
    notifyListeners();
  }

  int room_num;
  String room_name;
  String desc;
  String floor;
  Location location;
  Category roomCategory;

  deleteroom(room) async {
    await req.deleteRoom(room);
  }

  setNumNameDescFloorLocationCategory(
      {String name,
      int roomNum,
      String desc,
      String floor,
      Location location,
      Category category}) {
    this.room_name = name;
    this.room_num = roomNum;
    this.desc = desc;
    this.floor = floor;
    this.location = location;
    this.roomCategory = category;
    notifyListeners();
  }

  // getroom(int room_num) {
  //   uncategorized.forEach((element) {
  //     if (element.room_num == room_num) {
  //       return element;
  //     }
  //   });
  // }

  editRoom({int id, int locId}) async {
    Room room = Room(
        room_num: room_num,
        room_name: room_name,
        desc: desc,
        floor: floor,
        category: roomCategory,
        location: location,
        location_id: locId);
    await req.editRoom(room.toJson(), id);
    resetroomdata();
  }

  resetroomdata() {
    room_name = null;
    room_num = null;
    desc = null;
    floor = null;
    roomCategory = null;
    notifyListeners();
  }

  resetlogindetails() {
    mgs = null;
    userid = null;
    password = null;
    resetmgs();
    notifyListeners();
  }

  resetmgs() {
    mgs = null;
  }
}
