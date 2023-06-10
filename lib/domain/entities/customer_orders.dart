import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:foodyrest/domain/entities/order.dart';

class CustomerOrderNotifiee extends ChangeNotifier {
  List<CustomerOrders> pendingOrders = [];
  List<CustomerOrders> completed = [];

  void setCustomerOrders(List<CustomerOrders> orders) {
    pendingOrders.clear();
    completed.clear();
    orders.forEach((element) {
      if (element.delivery_Status) {
        completed.add(element);
      } else {
        pendingOrders.add(element);
      }
    });

    // notifyListeners();
  }

  void setStatus(CustomerOrders customerOrders) {
    int index = pendingOrders.indexOf(customerOrders);

    if (index != -1) {
      completed.add(pendingOrders.elementAt(index));
      pendingOrders.removeAt(index);
      notifyListeners();
    }
  }
}

class CustomerOrders {
  String order_id;
  String customer_name = '';
  bool mode = true;
  int total_amount = 0;
  bool delivery_Status = false;
  List<OrderFoodItem> orderfooditemlist = [];

  CustomerOrders(this.order_id, this.customer_name, this.mode,
      this.total_amount, this.delivery_Status, this.orderfooditemlist);

  factory CustomerOrders.fromJson(Map<String, dynamic> jsonData) {
    List<dynamic> orderItem = jsonData['orderFoodItemList'];

    List<OrderFoodItem> orders = orderItem
        .map<OrderFoodItem>(
          (e) => OrderFoodItem.fromJson(e),
        )
        .toList();

    return CustomerOrders(
      jsonData['order_id'],
      jsonData['customer_name'],
      jsonData['mode'],
      jsonData['total_amount'],
      jsonData['delivery_Status'],
      orders,
    );
  }
}
