import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:foodyrest/domain/entities/FoodItems.dart';
import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

class HttpClient {
  HttpClient();

  static const String BASEURL = "https://foodyrest.onrender.com";

  Future<http.Response> get(String url) async {
    Uri uri = parseUrl(url);

    return http.get(
      uri,
      headers: {"Content-Type": "application/json"},
    );
  }

  Future<void> post(String url, body) async {
    Uri uri = parseUrl(url);

    try {
      http.post(
        uri,
        body: jsonEncode(body),
        headers: {
          "Content-Type": "application/json",
        },
      );
    } catch (e) {
      print(e);
    }
  }

  Future<http.Response> getAllOrders() {
    return http.get(
      parseUrl("/allOrders"),
      headers: {"Content-Type": "application/json"},
    );
  }

  Future<http.Response> setStausToDelivered(String orderId) {
    return http.put(parseUrl("/setDeliverd/$orderId"));
  }
  // /setAvailability/{name}

  Future<http.Response> setFoodUnavailable(String name) {
    return http.put(parseUrl('/setAvailability/$name'));
  }
  // /add

  Future<http.Response> addFoodItem(String name, String img_url, int price) {
    return http.post(
      parseUrl('/add'),
      body: jsonEncode(
        FoodItem(name: name, img_url: img_url, price: price, available: true)
            .toJson(),
      ),
      headers: {
        "Content-Type": "application/json",
      },
    );
  }

  Uri parseUrl(String url) {
    Uri uri = Uri.parse(BASEURL + url);
    return uri;
  }
}
