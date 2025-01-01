import 'dart:convert';
import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_variables.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/auth/screens/auth_screen.dart';
import 'package:amazon_clone/models/order.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AccountServices {
  // Fetch user orders
  Future<List<Order>> fetchMyOrders({
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Order> orderList = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/api/orders/me'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          List<dynamic> orders = jsonDecode(res.body);
          for (var order in orders) {
            orderList.add(Order.fromJson(jsonEncode(order)));
          }
        },
      );
    } catch (e) {
      debugPrint("Fetch Orders Error: $e");
      showSnackBar(context, 'Failed to fetch orders. Please try again.');
    }
    return orderList;
  }

  // Log out user
  Future<void> logOut(BuildContext context) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.remove('x-auth-token'); // Use remove instead of set to clear token

      // Navigate to the AuthScreen and clear all previous routes
      Navigator.pushNamedAndRemoveUntil(
        context,
        AuthScreen.routeName,
        (route) => false,
      );

      showSnackBar(context, 'Logged out successfully.');
    } catch (e) {
      debugPrint("Logout Error: $e");
      showSnackBar(context, 'Failed to log out. Please try again.');
    }
  }
}
