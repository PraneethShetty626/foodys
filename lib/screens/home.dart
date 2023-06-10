import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foodyrest/domain/HttpClient/http_client.dart';
import 'package:foodyrest/domain/entities/FoodItems.dart';
import 'package:foodyrest/screens/comfirm_order.dart';
import 'package:foodyrest/widgets/food_item_card.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constants.dart';

import '../domain/entities/order.dart';
import '../widgets/category_icon_with_text.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double valueKm = 0;
  int foodItemsCount = 100;
  String match = '';

  List<FoodItem> parseFoodItems(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<FoodItem>((json) => FoodItem.fromJson(json)).toList();
  }

  Widget foods() {
    return FutureBuilder(
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data?.statusCode == 200) {
            var foodItems = parseFoodItems(snapshot.data!.body);
            foodItems = foodItems
                .where(
                  (element) =>
                      element.name.toLowerCase().contains(match.toLowerCase()),
                )
                .toList();

            return GridView.builder(
              physics:
                  const NeverScrollableScrollPhysics(), // to disable GridView's scrolling
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, crossAxisSpacing: 20, mainAxisSpacing: 20),
              itemBuilder: (context, index) => FoodItemCard(
                onTap: () {},
                backgroundColor: foodItems[index].available
                    ? Colors.primaries[index % Colors.primaries.length]
                    : Colors.black54,
                foodItem: foodItems[index],
              ),
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
      future: HttpClient().get("/getAllFoods"),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final Order order = Provider.of<Order>(context, listen: true);
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
                        "Find the best food",
                        style: largestText,
                      ),
                      RichText(
                        text: TextSpan(
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          children: [
                            TextSpan(text: "$foodItemsCount food items, "),
                            TextSpan(
                              text: "choose yours",
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
                  order;
                  showDialog(
                      context: context,
                      builder: (context) => ConfirmOrder(order));
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
                    "Confirm Order",
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
          foods()
        ],
      ),
    );
  }
}
