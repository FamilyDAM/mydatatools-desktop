import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

///
/// Useful modal popups and toast that are reused throughout the app
/// How to use
/// @see https://medium.com/@azharbinanwar/coding-made-easy-using-handy-extensions-on-buildcontext-46283b3655be
extension WidgetExtension<T> on BuildContext {
  Future<T?> showBottomSheet(
    Widget child, {
    bool isScrollControlled = true,
    Color? backgroundColor,
    Color? barrierColor,
  }) {
    return showModalBottomSheet(
      context: this,
      barrierColor: barrierColor,
      isScrollControlled: isScrollControlled,
      backgroundColor: backgroundColor,
      builder: (context) => Wrap(children: [child]),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(String message) {
    return ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating, duration: const Duration(seconds: 1),
        // backgroundColor: primary,
      ),
    );
  }

  Future<bool?> showToast(String message) {
    return Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      //backgroundColor: primary,
      //textColor: onPrimary,
    );
  }
}
