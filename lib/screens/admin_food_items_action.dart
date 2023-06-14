import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodyrest/domain/HttpClient/http_client.dart';
import 'package:foodyrest/domain/entities/FoodItems.dart';
import 'package:foodyrest/domain/entities/current_section.dart';
import 'package:foodyrest/screens/add_food.dart';
import 'package:foodyrest/screens/comfirm_order.dart';
import 'package:foodyrest/widgets/food_item_card.dart';
import 'package:foodyrest/widgets/food_setting_food_item_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constants.dart';

import '../domain/entities/order.dart';
import '../widgets/category_icon_with_text.dart';

class AdminFoodSetting extends StatefulWidget {
  const AdminFoodSetting({super.key});

  @override
  State<AdminFoodSetting> createState() => _AdminFoodSettingState();
}

class _AdminFoodSettingState extends State<AdminFoodSetting> {
  double valueKm = 0;
  int foodItemsCount = 1000;
  String match = '';
  List<FoodItem> foodItems = [];

  List<FoodItem> parseFoodItems(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();

    return parsed.map<FoodItem>((json) => FoodItem.fromJson(json)).toList();
  }

  void setStateR(String name, String image_url, int price) {
    foodItems.add(FoodItem(
        name: name, img_url: image_url, price: price, available: true));

    setState(() {});
  }

  Widget foods(String key) {
    return FutureBuilder(
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data?.statusCode == 200) {
            foodItems = parseFoodItems(snapshot.data!.body);
            foodItems = foodItems
                .where(
                  (element) =>
                      element.name.toLowerCase().contains(match.toLowerCase()),
                )
                .toList();
            // print(foodItems);

            return GridView.builder(
              physics:
                  const NeverScrollableScrollPhysics(), // to disable GridView's scrolling
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, crossAxisSpacing: 20, mainAxisSpacing: 20),
              itemBuilder: (context, index) =>
                  AdminFoodSettingOptions(foodItems[index]),
              itemCount: foodItems.length,
            );
          }

          return const Center(
            child: Text("NO data present"),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      }),
      future: HttpClient().getAllFoodSetting(key),
    );
  }

  @override
  Widget build(BuildContext context) {
    final instance = Provider.of<LoggedIn>(context, listen: false).instance;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: ListView(
        children: [
          Row(
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Let's make the best food",
                        style: largestText,
                      ),
                      RichText(
                        text: TextSpan(
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          children: [
                            TextSpan(
                                text:
                                    "Let's offer $foodItemsCount food items, "),
                            TextSpan(
                              text: "let them choose",
                              style: GoogleFonts.montserrat(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  // order;
                  showDialog(
                      context: context,
                      builder: (context) => AddFood(setStateR));
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 150,
                  height: 50,
                  margin: const EdgeInsets.only(right: 18),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black),
                  child: const Text(
                    "Add new Food item",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Row(
            children: [
              Expanded(
                flex: 10,
                child: CategoryIconWithText(),
              ),
              Spacer(),
              Expanded(
                flex: 4,
                child: Container(
                  width: 350,
                  margin: const EdgeInsets.all(15),
                  child: TextField(
                    onChanged: ((value) => setState(() {
                          match = value.trim();
                        })),
                    style: const TextStyle(fontSize: 12),
                    decoration: InputDecoration(
                      hintText: "Enter your search request...",
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 3, color: Color.fromARGB(255, 5, 47, 27)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 3, color: Color.fromARGB(255, 3, 26, 15)),
                      ),
                      prefixIcon: Container(
                        padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
                        child: const FaIcon(
                          FontAwesomeIcons.search,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 30),
          const SizedBox(height: 50),
          foods(instance!.getString("key")!)
        ],
      ),
    );
  }
}
