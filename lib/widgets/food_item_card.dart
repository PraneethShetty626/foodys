import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodyrest/domain/entities/order.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../domain/entities/FoodItems.dart';

class CountModel extends ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }

  void decrement() {
    _count--;
    notifyListeners();
  }
}

class FoodItemCard extends StatelessWidget {
  final Color backgroundColor;
  final FoodItem foodItem;
  final VoidCallback onTap;

  const FoodItemCard({
    Key? key,
    required this.backgroundColor,
    required this.foodItem,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final order = Provider.of<Order>(context, listen: false);
    // int count = 0;
    return Material(
      borderRadius: BorderRadius.circular(
        10.0,
      ),
      color: backgroundColor.withOpacity(0.2),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          10.0,
        ),
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
                      foodItem.img_url,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Column(
                children: [
                  Text(
                    foodItem.name,
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 3),
                  // Text(
                  //   foodItem.resType,
                  //   overflow: TextOverflow.ellipsis,
                  //   style: GoogleFonts.montserrat(
                  //     fontSize: 10,
                  //     color: Colors.grey.shade600,
                  //   ),
                  // ),
                ],
              ),
              // Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CurrencyIcon(size: 10),
                      //  Text("Price : ")
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    foodItem.price.toString(),
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
              Spacer(),
              Container(
                height: 50,
                child: IntrinsicHeight(
                  child: ChangeNotifierProvider.value(
                      value: CountModel(),
                      builder: (context, child) {
                        final countModel = Provider.of<CountModel>(context);
                        return Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                                onPressed: !foodItem.available
                                    ? null
                                    : () {
                                        if (countModel.count > 0) {
                                          countModel.decrement();
                                        }
                                        order.removeFoodItem(
                                            OrderFoodItem.fromFoodItem(
                                                foodItem));
                                      },
                                icon:
                                    Icon(Icons.remove_circle_outline_outlined)),
                            CustomDivider(height: 40),
                            Text(countModel.count.toString()),
                            CustomDivider(height: 40),
                            IconButton(
                                onPressed: !foodItem.available
                                    ? null
                                    : () {
                                        order.addFoodItem(
                                            OrderFoodItem.fromFoodItem(
                                                foodItem));
                                        countModel.increment();
                                      },
                                icon: Icon(Icons.add_circle)),
                          ],
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CurrencyIcon extends StatelessWidget {
  final double size;
  final Color color;
  const CurrencyIcon({
    Key? key,
    required this.size,
    this.color = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      "\$",
      style: GoogleFonts.montserrat(
        fontSize: size,
        fontWeight: FontWeight.bold,
        color: color,
      ),
    );
  }
}

class CustomDivider extends StatelessWidget {
  final double height;

  const CustomDivider({
    required this.height,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: height,
        width: 1,
        color: Colors.grey.shade500,
      ),
    );
  }
}
