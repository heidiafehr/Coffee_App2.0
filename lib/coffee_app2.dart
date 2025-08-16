import 'package:coffee_app_2/page_container_with_nav/page_container_with_nav.dart';
import 'package:flutter/material.dart';

class CoffeeApp2 extends StatelessWidget {
  const CoffeeApp2({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PageContainerWithNav(),
    );
  }
}
