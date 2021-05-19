import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:nilemap_frontend/Models/CategoryModel.dart';
import 'package:nilemap_frontend/Models/LocationModel.dart';
import 'package:nilemap_frontend/Models/RoomModel.dart';

Future<List> getAllLocation() async {
  //final url = Uri.parse('http://localhost:8000/api/home');
  final url = Uri.parse('https://nile-map.herokuapp.com/api/home');
  Map<String, String> headers = {"Content-type": "application/json"};
  String json =
      '{"lname":"Block B","longitude": "23846","latitude": "57648","rooms": [{"room_num": 106,"desc": "left by","floor": "first","rcategory_id": 4,"room_name":"Hod office"}],"user_id": 2,"type": "CREATE","activity_performed": "Added Block C location","category_id":2}';
  try {
// make POST request
    http.Response response = await http.get(url, headers: headers);
// check the status code for the result
// int statusCode = response.statusCode;
// // this API passes back the id of the new item added to the body
    //String body = response.body;
    //print(body);
    print("object");
    return jsonDecode(response.body).map((e) => Category.fromjson(e)).toList();
  } catch (e) {
    print(e);
  }
}

Future<List> getAllRoomsForALocation(int id) async {
  //final url = Uri.parse('http://localhost:8000/api/roomlist/$id');
  final url = Uri.parse('https://nile-map.herokuapp.com/api/roomlist/$id');
  Map<String, String> headers = {"Content-type": "application/json"};
  String json =
      '{"lname":"Block B","longitude": "23846","latitude": "57648","rooms": [{"room_num": 106,"desc": "left by","floor": "first","rcategory_id": 4,"room_name":"Hod office"}],"user_id": 2,"type": "CREATE","activity_performed": "Added Block C location","category_id":2}';
  try {
// make POST request
    http.Response response = await http.get(url, headers: headers);
// check the status code for the result
// int statusCode = response.statusCode;
// // this API passes back the id of the new item added to the body
    //String body = response.body;
    //print(body);
    print("object");
    return jsonDecode(response.body)
        .map((e) => Room(e['Room_num'], e['room_name'], e['Desc'], e['Floor']))
        .toList();
  } catch (e) {
    print(e);
  }
}
