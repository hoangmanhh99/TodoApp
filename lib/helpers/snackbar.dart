import 'package:flutter/material.dart';

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

showSnackBar(message) {
  var _snackBar = SnackBar(content: message, duration: Duration(milliseconds: 500),);
  scaffoldKey.currentState?.showSnackBar(_snackBar);
}