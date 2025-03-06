import 'package:flutter/material.dart';

class MenuModel {
  String icon;
  String title;
  String route;
  bool isSVG;
  bool isSignIn;

  MenuModel({
    @required this.icon,
    @required this.title,
    @required this.route,
    this.isSVG = false,
    this.isSignIn = false,
  });
}

class MenuModel1 {
  String path;
  String title;
  String route;
  bool isSVG;
  bool isSignIn;

  MenuModel1({
    @required this.path,
    @required this.title,
    @required this.route,
    this.isSVG = false,
    this.isSignIn = false,
  });
}
