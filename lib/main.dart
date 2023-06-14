import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:foodyrest/domain/entities/FoodItems.dart';
import 'package:foodyrest/domain/entities/current_section.dart';
import 'package:foodyrest/domain/entities/order.dart';
import 'package:foodyrest/screens/admin_food_items_action.dart';
import 'package:foodyrest/screens/admin_screen.dart';
import 'package:foodyrest/screens/home.dart';
import 'package:foodyrest/screens/sign_in_screen.dart';
import 'package:foodyrest/widgets/restaurant_list.dart';
import 'package:foodyrest/widgets/side_menu.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'domain/entities/customer_orders.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Order(),
        ),
        ChangeNotifierProvider(
          create: (_) => CurrentSection(),
        ),
        ChangeNotifierProvider(
          create: (_) => CustomerOrderNotifiee(),
        ),
        ChangeNotifierProvider(create: (_) => LoggedIn())
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: MainPage(),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _HomeState();
}

class _HomeState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    final cSection = Provider.of<CurrentSection>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Row(
            children: [
              const Expanded(
                flex: 2,
                child: SideMenu(),
              ),
              Expanded(
                flex: 7,
                child: cSection.cs == 0
                    ? const Home()
                    : cSection.cs == 1
                        ? SignInScreen()
                        : cSection.cs == 2
                            ? const AdminPage()
                            : AdminFoodSetting(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
