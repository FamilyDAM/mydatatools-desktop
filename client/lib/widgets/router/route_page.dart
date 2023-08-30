import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RoutePage extends NoTransitionPage {
  const RoutePage({
    required this.body,
    this.drawer,
    this.isStandalone = false,
    super.name,
    super.arguments,
    super.restorationId,
    super.key,
  }) : super(child: body);

  final bool isStandalone;
  final Widget body;
  final Widget? drawer;

  Widget build(BuildContext context) {
    return Container();
  }
}
