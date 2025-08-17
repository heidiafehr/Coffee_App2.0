import 'package:coffee_app_2/coffee_app2.dart';
import 'package:coffee_app_2/service_locator.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  setupDependencies();

  runApp(const CoffeeApp2());
}
