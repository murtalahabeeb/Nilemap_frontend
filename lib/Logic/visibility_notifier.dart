import 'package:flutter/material.dart';
import 'package:nilemap_frontend/Logic/backend_requests.dart';

class VisibilityNotifier extends ChangeNotifier {
  HttpService req = HttpService();
  bool isvisbleCheck = true;
  bool isvisiblepassword = false;
  bool loading = false;
  bool room = false;
  var mgs;

  isvisibleforcheck() {
    isvisbleCheck = !isvisbleCheck;
    notifyListeners();
  }

  isvisibleforpassword() {
    isvisiblepassword = !isvisiblepassword;
    notifyListeners();
  }

  isloading() {
    loading = !loading;
    notifyListeners();
  }

  isloadingforroom() {
    room = !room;
    notifyListeners();
  }

  bool obscure = true;
  setobscure() {
    obscure = !obscure;
    notifyListeners();
  }
}
