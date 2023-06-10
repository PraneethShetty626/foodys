import 'package:flutter/cupertino.dart';
import 'package:foodyrest/domain/entities/FoodItems.dart';
import 'package:provider/provider.dart';

class Order extends ChangeNotifier {
  String customer_name = '';
  bool mode = true;
  int total_amount = 0;
  bool delivery_Status = false;
  List<OrderFoodItem> orderfooditemlist = [];

  void setMode(bool val) {
    mode = val;
    // notifyListeners();
  }

  void addFoodItem(OrderFoodItem foodItem) {
    var index = orderfooditemlist.indexWhere(
      (element) => element.name == foodItem.name,
    );

    if (index == -1) {
      orderfooditemlist.add(foodItem);
    } else {
      orderfooditemlist[index].quantity++;
    }
    total_amount += foodItem.price;
    // notifyListeners();
  }

  void removeFoodItem(OrderFoodItem foodItem) {
    var index = orderfooditemlist.indexWhere(
      (element) => element.name == foodItem.name,
    );
    if (index != -1) {
      if (orderfooditemlist[index].quantity > 1) {
        orderfooditemlist[index].quantity--;
      } else {
        orderfooditemlist.removeAt(index);
      }
      total_amount -= foodItem.price;
    }
    // notifyListeners();
  }

  void reset() {
    customer_name = '';
    mode = true;
    total_amount = 0;
    delivery_Status = false;
    orderfooditemlist.clear();
    notifyListeners();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customer_name'] = customer_name;
    data['mode'] = mode;
    data['total_amount'] = total_amount;
    data['delivery_Status'] = delivery_Status;
    data['orderFoodItemList'] = orderfooditemlist;

    return data;
  }
}

class OrderFoodItem {
  String name;
  int quantity;
  int price;

  OrderFoodItem({
    this.quantity = 1,
    required this.name,
    required this.price,
  });

  factory OrderFoodItem.fromFoodItem(FoodItem foodItem) {
    return OrderFoodItem(
      name: foodItem.name,
      price: foodItem.price,
    );
  }

  factory OrderFoodItem.fromJson(Map<String, dynamic> json) {
    return OrderFoodItem(
        name: json['name'], price: json['price'], quantity: json['quantity']);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data["name"] = name;
    data["quantity"] = quantity;
    data["price"] = price;
    return data;
  }
}
