import 'package:flutter/material.dart';
import 'package:foodyrest/domain/entities/current_section.dart';
import 'package:foodyrest/domain/entities/order.dart';
import 'package:foodyrest/widgets/location_card.dart';
import 'package:foodyrest/widgets/menu_item.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../domain/entities/menu.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  int currentSelectedIndex = 0;
  bool isHovered = false;
  int? currentHoveredIndex;

  @override
  Widget build(BuildContext context) {
    final cSection = Provider.of<CurrentSection>(context, listen: false);
    final order = Provider.of<Order>(context, listen: false);

    return Container(
      color: Colors.black,
      child: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "I",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(width: 5),
              Icon(
                Icons.favorite,
                color: Colors.white,
                size: 18,
              ),
              const SizedBox(width: 5),
              Text(
                "Food",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Container(
            height: 60,
            width: 60,
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Colors.blue,
                  Colors.purple,
                  Colors.pink,
                ],
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset(
                "assets/logo.jpg",
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Welcome To",
            style: TextStyle(color: kGreyColor),
          ),
          const SizedBox(height: 10),
          const Text(
            "FoodyRest",
            style: TextStyle(
                color: kWhiteColor, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 20),
          ...menuList
              .asMap()
              .map((index, item) => MapEntry(
                  index,
                  MenuItemC(
                    text: item.title,
                    icon: item.icon,
                    onTap: () {
                      cSection.setSection(index);

                      setState(() {
                        currentSelectedIndex = index;
                      });
                      order.reset();
                    },
                    isSeleted: index == currentSelectedIndex,
                    onHover: (value) {
                      if (value) {
                        setState(() {
                          currentHoveredIndex = index;
                        });
                      } else {
                        setState(() {
                          currentHoveredIndex = null;
                        });
                      }
                    },
                    isHovered: currentHoveredIndex == index,
                  )))
              .values
              .toList(),
          Spacer(),
          LocationCardWidget(),
        ],
      ),
    );
  }
}
