import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:foodyrest/domain/entities/order.dart';
import 'package:foodyrest/widgets/custom_text_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../domain/HttpClient/http_client.dart';

class ConfirmOrder extends StatefulWidget {
  final Order order;
  const ConfirmOrder(this.order, {super.key});

  @override
  State<ConfirmOrder> createState() => _ConfirmOrderState();
}

class _ConfirmOrderState extends State<ConfirmOrder> {
  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    bool val = true;
    final formKey = GlobalKey<FormState>();
    return AlertDialog(
      contentPadding: const EdgeInsets.all(0),
      content: Container(
        width: 750,
        height: 700,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Confirm Order",
                      style: GoogleFonts.aclonica(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            widget.order.orderfooditemlist.isNotEmpty
                ? Expanded(
                    child: ListView(
                      children: [
                        Container(
                            width: 350,
                            margin: const EdgeInsets.all(15),
                            child: Column(
                              children: [
                                Form(
                                  key: formKey,
                                  child: TextFormField(
                                    style: const TextStyle(fontSize: 12),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Please enter your name';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      widget.order.customer_name = value!;
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Please Enter your name",
                                      label: const Text("Customer Name"),
                                      enabledBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 3,
                                            color:
                                                Color.fromARGB(255, 5, 47, 27)),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            width: 3,
                                            color:
                                                Color.fromARGB(255, 3, 26, 15)),
                                      ),
                                      prefixIcon: Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 15, 10, 10),
                                        child: const FaIcon(
                                          FontAwesomeIcons.search,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                CheckBoxMode()
                              ],
                            )),
                        OrderListTitle(),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => OrderItemListItem(
                              widget.order.orderfooditemlist.elementAt(index)),
                          itemCount: widget.order.orderfooditemlist.length,
                        ),
                      ],
                    ),
                  )
                : Spacer(),
            Column(
              children: [
                DetailInfo(
                  title: "Your Total Amount",
                  info: widget.order.total_amount.toString(),
                  fontWeight: FontWeight.bold,
                )
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child:
                          const Text("Cancel", style: TextStyle(fontSize: 12)),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    CustomTextButton(
                      text: "Save",
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          if (widget.order.orderfooditemlist.isNotEmpty) {
                            HttpClient()
                                .post("/order", widget.order.toJson())
                                .then((value) => Navigator.of(context).pop())
                                .then((value) => widget.order.reset())
                                .onError((error, stackTrace) => print(error))
                                .then((value) => showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                          actions: [
                                            CustomTextButton(
                                                text: "Close",
                                                onTap: (() =>
                                                    Navigator.of(context)
                                                        .pop()))
                                          ],
                                          content: const Text(
                                              "Order placed succesffully")),
                                    ));
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CheckBoxMode extends StatefulWidget {
  const CheckBoxMode({super.key});

  @override
  State<CheckBoxMode> createState() => _CheckBoxModeState();
}

class _CheckBoxModeState extends State<CheckBoxMode> {
  bool val = true;
  @override
  Widget build(BuildContext context) {
    final order = Provider.of<Order>(context, listen: false);
    return CheckboxListTile(
        title: const Text("Dine in"),
        value: val,
        onChanged: ((value) {
          order.setMode(value!);
          // widget.order.mode = value!;
          // print(widget.order.mode);
          setState(() {
            val = value;
          });
          // print(val);
          // print(value);
          // print("\n");
        }));
  }
}

class OrderListTitle extends StatelessWidget {
  const OrderListTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          SizedBox(
            width: 150,
            child: Text(
              "Item",
              style: GoogleFonts.montserrat(
                fontSize: 15,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          const Spacer(),
          Text("Price",
              style: GoogleFonts.montserrat(
                fontSize: 15,
                fontWeight: FontWeight.normal,
              )),
          Text(" X ",
              style: GoogleFonts.montserrat(
                fontSize: 15,
                fontWeight: FontWeight.normal,
              )),
          Text("Quantity",
              style: GoogleFonts.montserrat(
                fontSize: 15,
                fontWeight: FontWeight.normal,
              )),
          const Spacer(),
          Text(
            "Total",
            style: GoogleFonts.montserrat(
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

class OrderItemListItem extends StatelessWidget {
  final OrderFoodItem orderFoodItem;
  const OrderItemListItem(this.orderFoodItem, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 150,
            child: Text(
              orderFoodItem.name,
              style: GoogleFonts.montserrat(
                fontSize: 15,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          const Spacer(),
          Text(orderFoodItem.price.toString(),
              style: GoogleFonts.montserrat(
                fontSize: 15,
                fontWeight: FontWeight.normal,
              )),
          Text(" X ",
              style: GoogleFonts.montserrat(
                fontSize: 15,
                fontWeight: FontWeight.normal,
              )),
          Text(orderFoodItem.quantity.toString(),
              style: GoogleFonts.montserrat(
                fontSize: 15,
                fontWeight: FontWeight.normal,
              )),
          Spacer(),
          Text(
            (orderFoodItem.price * orderFoodItem.quantity).toString(),
            style: GoogleFonts.montserrat(
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

class DetailInfo extends StatelessWidget {
  final String title;
  final String info;
  final FontWeight fontWeight;

  const DetailInfo({
    Key? key,
    required this.title,
    required this.info,
    this.fontWeight = FontWeight.normal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            // width: 150,
            child: Text(
              title,
              style: GoogleFonts.montserrat(
                fontSize: 15,
                fontWeight: fontWeight,
              ),
            ),
          ),
          Spacer(),
          Text(
            info,
            style: GoogleFonts.montserrat(
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}
