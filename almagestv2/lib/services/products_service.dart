import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:almagestv2/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:almagestv2/models/models.dart';

class ProductsService extends ChangeNotifier {
  final String baseURL = 'semillero.allsites.es';
  final storage = const FlutterSecureStorage();
  bool isLoading = true;
  final List<ProductData> products = [];
  final UserService userService = UserService();

  Future<List<ProductData>> getProducts() async {
    String? token = await userService.readToken();
    final url = Uri.http(baseURL, '/public/api/products', {});
    isLoading = true;
    notifyListeners();

    final response = await http.get(
      url,
      headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        "Authorization": "Bearer $token",
      },
    );

    final Map<String, dynamic> decoded = json.decode(response.body);
    var product = Products.fromJson(decoded);
    for (var i in product.data!) {
      products.add(i);
    }
    isLoading = false;
    notifyListeners();
    return products;
  }
}
