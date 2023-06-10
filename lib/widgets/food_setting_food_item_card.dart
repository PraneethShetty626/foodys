import 'dart:math';

import 'package:flutter/material.dart';
import 'package:foodyrest/domain/HttpClient/http_client.dart';
import 'package:foodyrest/domain/entities/FoodItems.dart';
import 'package:google_fonts/google_fonts.dart';

import 'food_item_card.dart';

class AdminFoodSettingOptions extends StatefulWidget {
  final FoodItem foodItem;
  const AdminFoodSettingOptions(this.foodItem, {super.key});

  @override
  State<AdminFoodSettingOptions> createState() =>
      _AdminFoodSettingOptionsState();
}

class _AdminFoodSettingOptionsState extends State<AdminFoodSettingOptions> {
  bool isAvailable = true;

  void toggle() {
    setState(() {
      isAvailable = !isAvailable;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isAvailable = widget.foodItem.available;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(
        10.0,
      ),
      color: isAvailable
          ? Colors
              .primaries[Random().nextInt(54551255) % Colors.primaries.length]
              .withOpacity(0.2)
          : Colors.black54.withOpacity(0.2),
      child: Container(
        height: 275,
        width: 220,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: SizedBox(
                width: 180,
                child: AspectRatio(
                  aspectRatio: 1.5,
                  child: Image.network(
                    widget.foodItem.img_url,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const Spacer(),
            Column(
              children: [
                Text(
                  widget.foodItem.name,
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
                const SizedBox(height: 3),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    CurrencyIcon(size: 10),
                    //  Text("Price : ")
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  widget.foodItem.price.toString(),
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Available",
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
                Switch(
                    value: isAvailable,
                    onChanged: (val) => HttpClient()
                        .setFoodUnavailable(widget.foodItem.name)
                        .then((value) => toggle())
                        .onError((error, stackTrace) => print(error))),
              ],
            )
          ],
        ),
      ),
    );
  }
}
