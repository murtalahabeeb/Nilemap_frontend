import 'package:flutter/material.dart';

class OvalContainer extends StatelessWidget {
  final Widget child;
  OvalContainer(this.child);
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.all(
              Radius.circular(20.0),
            ),
          ),
          width: width * 0.9,
          child: Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: child),
        ),
      ),
    );
  }
}
