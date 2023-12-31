import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../domain/entities/category.dart';


class CategoryIconWithText extends StatelessWidget {
  const CategoryIconWithText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      width: double.infinity,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: categories.length ,
        itemBuilder: (context, index) {
          

          return Padding(
            padding: const EdgeInsets.only(right: 30),
            child: Column(
              children: [
                Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(50.0),
                    child: InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(50.0),
                      child: CircleAvatar(
                        backgroundColor: Colors
                            .primaries[index % Colors.primaries.length]
                            .withOpacity(0.5),
                        child: FaIcon(
                          categories[index].icon,
                          color: Colors.black,
                          size: 16,
                        ),
                      ),
                    )),
                const SizedBox(height: 10),
                Text(
                  categories[index].text.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
