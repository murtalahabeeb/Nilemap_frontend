import 'dart:collection';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:nilemap_frontend/Backend_requests/location_requests.dart';

class LocationNotifier extends ChangeNotifier {
  List<dynamic> _locList = [];
  List<dynamic> _roomList = [];

  UnmodifiableListView<dynamic> get locList => UnmodifiableListView(_locList);
  UnmodifiableListView<dynamic> get roomList => UnmodifiableListView(_roomList);
  getLocation() async {
    _locList = await getAllLocation();
    notifyListeners();
  }

  getLocRoom(int id) async {
    _roomList = await getAllRoomsForALocation(id);
    notifyListeners();
  }
}
