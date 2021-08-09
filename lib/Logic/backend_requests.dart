import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:http/http.dart' as http;
import 'package:nilemap_frontend/Logic/shared_preferences.dart';
import 'package:nilemap_frontend/Models/ActivityModel.dart';
import 'package:nilemap_frontend/Models/AdminModel.dart';
import 'package:nilemap_frontend/Models/CategoryModel.dart';
import 'package:nilemap_frontend/Models/DeletedModel.dart';
import 'package:nilemap_frontend/Models/LocationModel.dart';
import 'package:nilemap_frontend/Models/RoomModel.dart';

class HttpService {
  String hosted;
  getplatform() {
    if (Platform.isIOS) {
      // hosted = 'http://localhost:8000/api/';
      hosted = 'https://nile-map.herokuapp.com/api/';
    } else if (Platform.isAndroid) {
      //hosted = 'http://10.0.2.2:8000/api/';
      hosted = 'https://nile-map.herokuapp.com/api/';
    }
  }

  //final hosted = 'http://localhost:8000/api/';
  //final hosted = 'https://nile-map.herokuapp.com/api/';
  Future<Map<String, dynamic>> getAllLocation() async {
    getplatform();
    //final url = Uri.parse('http://localhost:8000/api/categories');
    final url = Uri.parse(hosted + 'categories');
    Map<String, String> headers = {"Content-type": "application/json"};

    // try {
// make POST request
    http.Response response = await http.get(url, headers: headers);
// check the status code for the result
// int statusCode = response.statusCode;
// // this API passes back the id of the new item added to the body
    final categorized = jsonDecode(response.body)['categories']
        .map<Category>((categories) => Category.fromjson(categories))
        .toList();
    final uncategorized =
        Category.uncategorized(jsonDecode(response.body)['uncategorized']);
    return {'categorized': categorized, 'uncategorized': uncategorized};
    //} catch (e) {
    // return e; // error thrownx
    //}
  }

//   Future<List> getUncategorizedLocations() async {
//     getplatform();
//     //final url = Uri.parse('http://localhost:8000/api/uncategorizedlocations');
//     final url = Uri.parse(hosted + 'uncategorizedlocations');
//     Map<String, String> headers = {"Content-type": "application/json"};

//     try {
// // make POST request
//       http.Response response = await http.get(url, headers: headers);
// // check the status code for the result
// // int statusCode = response.statusCode;
// // // this API passes back the id of the new item added to the body

//       return jsonDecode(response.body)
//           .map<Location>((e) => Location.fromjson(e))
//           .toList();
//     } catch (e) {
//       print(e);
//       return Future.error(e);
//     }
//   }

//   Future<List> getUncategorizedRooms() async {
//     getplatform();
//     //final url = Uri.parse('http://localhost:8000/api/uncategorizedrooms');
//     final url = Uri.parse(hosted + 'uncategorizedrooms');
//     Map<String, String> headers = {"Content-type": "application/json"};

//     try {
// // make POST request
//       http.Response response = await http.get(url, headers: headers);
// // check the status code for the result
// // int statusCode = response.statusCode;
// // // this API passes back the id of the new item added to the body

//       return jsonDecode(response.body)
//           .map<Room>((e) => Room.fromjson(e))
//           .toList();
//     } catch (e) {
//       print(e);
//       return Future.error(e);
//     }
//   }

  Future<List<Room>> getAllRoomsForALocation(int id) async {
    getplatform();
    //final url = Uri.parse('http://localhost:8000/api/roomlist/$id');
    final url = Uri.parse(hosted + 'roomlist/$id');
    Map<String, String> headers = {"Content-type": "application/json"};

    try {
// make POST request
      http.Response response = await http.get(url, headers: headers);
// check the status code for the result
// int statusCode = response.statusCode;
// // this API passes back the id of the new item added to the body

      return jsonDecode(response.body)
          .map<Room>((e) => Room(
              room_num: e['Room_no'],
              room_name: e['room_name'],
              desc: e['Desc'],
              location_id: e['location_id'],
              floor: e['Floor'],
              category_id: e['category_id']))
          .toList();
    } catch (e) {
      print(e);
      return e;
    }
  }

  loginUser(int user_id, String password) async {
    getplatform();
    //final url = Uri.parse('http://localhost:8000/api/login');
    final url = Uri.parse(hosted + 'login');
    Map<String, String> headers = {"Content-type": "application/json"};

    String json = '{"user_id":$user_id ,"password":$password}';

    try {
// make POST request
      http.Response response =
          await http.post(url, headers: headers, body: json);
// check the status code for the result
      int statusCode = response.statusCode;
// // this API passes back the id of the new item added to the body

      if (response.statusCode == 404) {
        return statusCode;
      }
      var data = jsonDecode(response.body);
      return Admin.login(data);
    } catch (e) {
      print(e);
      return e;
    }
  }

  Future<Admin> getUser(int user_id, String token) async {
    getplatform();
    //final url = Uri.parse('http://localhost:8000/api/getuser/$user_id');
    final url = Uri.parse(hosted + 'getuser/$user_id');
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": 'Bearer $token'
    };

    try {
// make POST request
      http.Response response = await http.get(
        url,
        headers: headers,
      );
// check the status code for the result
// // this API passes back the id of the new item added to the body

      var data = jsonDecode(response.body);
      return Admin.fromjson(data);
    } catch (e) {
      print("thrown");
      rethrow;
    }
  }

  logoutUser(String token) async {
    getplatform();
    //final url = Uri.parse('http://localhost:8000/api/logout');
    final url = Uri.parse(hosted + 'logout');
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": 'Bearer $token'
    };

    try {
// make POST request
      http.Response response = await http.post(url, headers: headers);
// check the status code for the result
      int statusCode = response.statusCode;
// // this API passes back the id of the new item added to the body
      String body = response.body;
      print(body);
      print(statusCode);
      if (response.statusCode == 404) {
        return statusCode;
      }
      var data = jsonDecode(response.body);
      return data['message'];
    } catch (e) {
      print(e);
      return e;
    }
  }

  saveNewLocation(Map<String, dynamic> map) async {
    getplatform();
    UserPreferences user = UserPreferences();
    //final url = Uri.parse('http://localhost:8000/api/add');
    final url = Uri.parse(hosted + 'add');
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": 'Bearer ${user.token}'
    };

    map.addAll({
      "user_id": user.id,
      "type": "CREATE",
      "activity_performed": "Added ${map['lname'].toUpperCase()} as a location"
    });
    String json = jsonEncode(map);

    try {
// make POST request
      http.Response response =
          await http.post(url, headers: headers, body: json);
// check the status code for the result
      int statusCode = response.statusCode;
// // this API passes back the id of the new item added to the body
      String body = response.body;
      print(body);
      print(statusCode);
      if (response.statusCode == 404) {
        return statusCode;
      }
      var data = jsonDecode(response.body);
      return data['status'];
    } catch (e) {
      print(e);
      return e;
    }
  }

  editLocation(Map<String, dynamic> map) async {
    getplatform();
    UserPreferences user = UserPreferences();
    //final url =
    // Uri.parse('http://localhost:8000/api/update/${map['Location_id']}');
    final url = Uri.parse(hosted + 'update/${map['Location_id']}');
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": 'Bearer ${user.token}'
    };

    map.addAll({
      "user_id": user.id,
      "type": "EDIT",
      "activity_performed": "Edited location ${map['lname'].toUpperCase()}"
    });
    String json = jsonEncode(map);

    try {
// make POST request
      http.Response response =
          await http.post(url, headers: headers, body: json);
// check the status code for the result
      int statusCode = response.statusCode;
// // this API passes back the id of the new item added to the body
      String body = response.body;
      print(body);
      print(statusCode);
      if (response.statusCode == 404) {
        return statusCode;
      }
      var data = jsonDecode(response.body);
      return data['status'];
    } catch (e) {
      print(e);
      return e;
    }
  }

  deleteLocation(Location loc) async {
    getplatform();
    UserPreferences user = UserPreferences();
    //final url = Uri.parse('http://localhost:8000/api/delete/${loc.id}');
    final url = Uri.parse(hosted + 'delete/${loc.id}');
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": 'Bearer ${user.token}'
    };

    String json = '{"deleted": "${loc.name}"}';

    try {
// make POST request
      http.Response response =
          await http.post(url, headers: headers, body: json);
// check the status code for the result
      int statusCode = response.statusCode;
// // this API passes back the id of the new item added to the body
      String body = response.body;
      print(body);
      print(statusCode);
      if (response.statusCode == 404) {
        return statusCode;
      }
      var data = jsonDecode(response.body);
      return data['status'];
    } catch (e) {
      print(e);
      return e;
    }
  }

  addCategory(Map<String, dynamic> map) async {
    getplatform();
    UserPreferences user = UserPreferences();
    //final url = Uri.parse('http://localhost:8000/api/addcategory');
    final url = Uri.parse(hosted + 'addcategory');
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": 'Bearer ${user.token}'
    };
    map.addAll({
      "user_id": user.id,
      "type": "CREATE",
      "activity_performed": "Created ${map['name'].toUpperCase()} category"
    });
    String json = jsonEncode(map);

    try {
// make POST request
      http.Response response =
          await http.post(url, headers: headers, body: json);
// check the status code for the result
      int statusCode = response.statusCode;
// // this API passes back the id of the new item added to the body
      String body = response.body;
      print(body);
      print(statusCode);
      if (response.statusCode == 404) {
        return statusCode;
      }
      var data = jsonDecode(response.body);
      return data['status'];
    } catch (e) {
      print(e);
      return e;
    }
  }

  deletecategory(Category category) async {
    getplatform();
    UserPreferences user = UserPreferences();
    //final url =
    //Uri.parse('http://localhost:8000/api/deletecategory/${category.id}');
    final url = Uri.parse(hosted + 'deletecategory/${category.id}');
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": 'Bearer ${user.token}'
    };

    String json =
        '{"user_id": ${user.id},"type": "DELETE","deleted": "Deleted ${category.name.toUpperCase()} category"}';

    try {
// make POST request
      http.Response response =
          await http.post(url, headers: headers, body: json);
// check the status code for the result
      int statusCode = response.statusCode;
// // this API passes back the id of the new item added to the body
      String body = response.body;
      print(body);
      print(statusCode);
      if (response.statusCode == 404) {
        return statusCode;
      }
      var data = jsonDecode(response.body);
      return data['status'];
    } catch (e) {
      print(e);
      return e;
    }
  }

  editCategory(Map<String, dynamic> map) async {
    getplatform();
    UserPreferences user = UserPreferences();
    final url = Uri.parse(hosted + 'updatecategory/${map['id']}');
    //final url = Uri.parse('http://localhost:8000/api/add');
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": 'Bearer ${user.token}'
    };

    map.addAll({
      "user_id": user.id,
      "type": "EDIT",
      "activity_performed": "Edited Category ${map['name'].toUpperCase()}"
    });
    String json = jsonEncode(map);

    try {
// make POST request
      http.Response response =
          await http.post(url, headers: headers, body: json);
// check the status code for the result
      int statusCode = response.statusCode;
// // this API passes back the id of the new item added to the body
      String body = response.body;
      print(body);
      print(statusCode);
      if (response.statusCode == 404) {
        return statusCode;
      }
      var data = jsonDecode(response.body);
      return data['status'];
    } catch (e) {
      print(e);
      return e;
    }
  }

  editRoom(Map<String, dynamic> map, int id) async {
    getplatform();
    UserPreferences user = UserPreferences();
    //final url = Uri.parse('http://localhost:8000/api/updateroom/$id');
    final url = Uri.parse(hosted + 'updateroom/$id');
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": 'Bearer ${user.token}'
    };

    map.addAll({
      "user_id": user.id,
      "type": "EDIT",
      "activity_performed": "Edited Room ${map['room_name'].toUpperCase()}"
    });
    String json = jsonEncode(map);

    try {
// make POST request
      http.Response response =
          await http.post(url, headers: headers, body: json);
// check the status code for the result
      int statusCode = response.statusCode;
// // this API passes back the id of the new item added to the body
      String body = response.body;
      print(body);
      print(statusCode);
      if (response.statusCode == 404) {
        return statusCode;
      }
      var data = jsonDecode(response.body);
      return data['status'];
    } catch (e) {
      print(e);
      return e;
    }
  }

  deleteRoom(Room room) async {
    getplatform();
    UserPreferences user = UserPreferences();
    //final url =
    //Uri.parse('http://localhost:8000/api/deleteroom/${room.room_num}');
    final url = Uri.parse(hosted + 'deleteroom/${room.room_num}');
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": 'Bearer ${user.token}'
    };

    String json =
        '{"user_id": ${user.id},"deleted": "${room.room_name}","activity_performed": "Deleted room ${room.room_num} "}';

    try {
// make POST request
      http.Response response =
          await http.post(url, headers: headers, body: json);
// check the status code for the result
      int statusCode = response.statusCode;
// // this API passes back the id of the new item added to the body
      String body = response.body;
      print(body);
      print(statusCode);
      if (response.statusCode == 404) {
        return statusCode;
      }
      var data = jsonDecode(response.body);
      return data['status'];
    } catch (e) {
      print(e);
      return e;
    }
  }

  activiies() async {
    getplatform();
    UserPreferences user = UserPreferences();
    //final url =
    //Uri.parse('http://localhost:8000/api/deleteroom/${room.room_num}');
    final url = Uri.parse(hosted + 'activities');
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": 'Bearer ${user.token}'
    };

    try {
// make POST request
      http.Response response = await http.get(url, headers: headers);
// check the status code for the result
      int statusCode = response.statusCode;
// // this API passes back the id of the new item added to the body
      String body = response.body;
      print(body);
      print(statusCode);
      if (response.statusCode == 404) {
        return statusCode;
      }
      List<Activity> activities = jsonDecode(response.body)['all_activities']
          .map<Activity>((e) => Activity.fromjson(e))
          .toList();

      List<Deleted> deleted = jsonDecode(response.body)['deleted']
          .map<Deleted>((e) => Deleted.fromjson(e))
          .toList();
      return {'all_activities': activities, 'deleted': deleted};
    } catch (e) {
      print(e);
      return e;
    }
  }

  checkpassword(String password) async {
    getplatform();
    UserPreferences user = UserPreferences();
    //final url =
    //Uri.parse('http://localhost:8000/api/deleteroom/${room.room_num}');
    final url = Uri.parse(hosted + 'checkpassword/${user.id}');
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": 'Bearer ${user.token}'
    };

    try {
// make POST request
      http.Response response = await http.post(url,
          headers: headers, body: jsonEncode({'currentPassword': password}));
// check the status code for the result
      int statusCode = response.statusCode;
// // this API passes back the id of the new item added to the body
      String body = response.body;
      print(body);
      print(statusCode);
      if (response.statusCode == 404) {
        return statusCode;
      }
      return jsonDecode(body);
    } catch (e) {
      print(e);
      return e;
    }
  }

  changepassword(String password, String confirm) async {
    getplatform();
    UserPreferences user = UserPreferences();
    //final url =
    //Uri.parse('http://localhost:8000/api/deleteroom/${room.room_num}');
    final url = Uri.parse(hosted + 'changepassword/${user.id}');
    Map<String, String> headers = {
      "Content-type": "application/json",
      "Authorization": 'Bearer ${user.token}'
    };

    try {
// make POST request
      http.Response response = await http.post(url,
          headers: headers,
          body: jsonEncode({'password': password, 'confirm': confirm}));
// check the status code for the result
      int statusCode = response.statusCode;
// // this API passes back the id of the new item added to the body
      String body = response.body;
      print(body);
      print(statusCode);
      if (response.statusCode == 404) {
        return statusCode;
      }
      return jsonDecode(body);
    } catch (e) {
      print(e);
      return e;
    }
  }
}
