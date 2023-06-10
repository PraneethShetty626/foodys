import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:foodyrest/domain/HttpClient/http_client.dart';
import 'package:foodyrest/domain/entities/customer_orders.dart';
import 'package:foodyrest/widgets/custom_text_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(10),
      child: AllOrders(),
    );
  }
}

class AllOrders extends StatefulWidget {
  const AllOrders({super.key});

  @override
  State<AllOrders> createState() => _AllOrdersState();
}

class _AllOrdersState extends State<AllOrders> {
  List<CustomerOrders> parseFoodItems(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed
        .map<CustomerOrders>((json) => CustomerOrders.fromJson(json))
        .toList();
  }

  int cindex = 0;

  @override
  Widget build(BuildContext context) {
    final customerOrderNotifiee =
        Provider.of<CustomerOrderNotifiee>(context, listen: true);
    return FutureBuilder(
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            List<CustomerOrders> allOrders =
                parseFoodItems(snapshot.data!.body);

            customerOrderNotifiee.setCustomerOrders(allOrders);
            List<List<CustomerOrders>> options = [
              customerOrderNotifiee.pendingOrders,
              customerOrderNotifiee.completed
            ];
            return ListView(
              children: [
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          cindex = 0;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Pending Order",
                                style: GoogleFonts.aclonica(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      cindex == 1 ? Colors.black : Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          cindex = 1;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Completed Orders",
                                style: GoogleFonts.aclonica(
                                  fontSize: 20,
                                  color:
                                      cindex == 0 ? Colors.black : Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 25,
                      mainAxisSpacing: 25),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: ((context, index) {
                    return OrderCard(options[cindex][index]);
                  }),
                  itemCount: options[cindex].length,
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      }),
      future: HttpClient().getAllOrders(),
    );
  }
}

class OrderCard extends StatefulWidget {
  final CustomerOrders customerOrders;
  const OrderCard(this.customerOrders, {super.key});

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final customerOrderNotifiee =
        Provider.of<CustomerOrderNotifiee>(context, listen: false);

    return Material(
      borderRadius: BorderRadius.circular(
        10.0,
      ),
      color: Colors
          .primaries[Random().nextInt(500000) % Colors.primaries.length]
          .withOpacity(0.2),
      child: Container(
        // width: 100,
        // height: 100,
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            element("Customer Name", widget.customerOrders.customer_name),
            element(
                "Total Amount", widget.customerOrders.total_amount.toString()),
            element("Service Mode",
                widget.customerOrders.mode ? "Dine In" : "Parcel"),
            element("Item Name", "ItemCount", text3: "Item Price"),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: widget.customerOrders.orderfooditemlist
                    .map((e) => element(e.name, e.quantity.toString(),
                        text3: e.price.toString(),
                        fontWeight: FontWeight.normal))
                    .toList(),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            if (!widget.customerOrders.delivery_Status)
              CustomTextButton(
                  text: 'Confirm Deliverd',
                  onTap: () {
                    HttpClient()
                        .setStausToDelivered(widget.customerOrders.order_id)
                        .then((value) => showDialog(
                            context: context,
                            builder: ((context) => AlertDialog(
                                  content: const Text(
                                      "Order Status Changed Successfully"),
                                  actions: [
                                    CustomTextButton(
                                        text: "Close",
                                        onTap: () =>
                                            Navigator.of(context).pop())
                                  ],
                                ))))
                        .then((value) => customerOrderNotifiee
                            .setStatus(widget.customerOrders))
                        .onError((error, stackTrace) => print('Error'));
                  })
          ],
        ),
      ),
    );
  }
}

Padding element(String text, String text2,
    {String text3 = '', FontWeight fontWeight = FontWeight.bold}) {
  return Padding(
    padding: const EdgeInsets.all(10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 120,
          alignment: Alignment.centerLeft,
          child: Text(text,
              style:
                  GoogleFonts.alegreyaSc(fontSize: 15, fontWeight: fontWeight)),
        ),
        if (text3.isNotEmpty) Spacer(),
        if (text3.isNotEmpty)
          Container(
            width: 75,
            alignment: Alignment.center,
            child: Text(text3,
                style: GoogleFonts.alegreyaSc(
                    fontSize: 15, fontWeight: fontWeight)),
          ),
        Spacer(),
        Container(
          width: 135,
          alignment: Alignment.centerRight,
          child: Text(text2,
              style:
                  GoogleFonts.alegreyaSc(fontSize: 15, fontWeight: fontWeight)),
        ),
      ],
    ),
  );
}
