import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Menu {
  final IconData icon;
  final String title;

  Menu(this.icon, this.title);
}

final List<Menu> menuList = [
  Menu(FontAwesomeIcons.home, "Home"),
  // Menu(FontAwesomeIcons.slack, "Categories"),
  Menu(FontAwesomeIcons.solidHeart, "Admin Login/Logout"),
  Menu(FontAwesomeIcons.clipboardCheck, "Orders"),
  Menu(FontAwesomeIcons.productHunt, "Food Item's")
];
