import 'package:coffee_app_2/coffee_app2.dart';
import 'package:coffee_app_2/service_locator.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupDependencies();

  runApp(const CoffeeApp2());
}
