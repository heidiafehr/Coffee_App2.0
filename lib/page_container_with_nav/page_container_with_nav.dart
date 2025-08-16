import 'package:coffee_app_2/favorites_screen/favorites_screen.dart';
import 'package:coffee_app_2/generate_screen/generate_screen.dart';
import 'package:coffee_app_2/welcome_screen/welcome_screen.dart';
import 'package:flutter/material.dart';

class PageContainerWithNav extends StatefulWidget {
  final int initialIndex;
  const PageContainerWithNav({super.key, this.initialIndex = 0});

  @override
  PageContainerWithNavState createState() => PageContainerWithNavState();
}

class PageContainerWithNavState extends State<PageContainerWithNav> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  List<Widget> _buildPages() {
    return [WelcomeScreen(), GenerateScreen(), FavoritesScreen()];
  }

  @override
  Widget build(BuildContext context) {
    final pages = _buildPages();

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.coffee_outlined), label: 'Coffee'),
          NavigationDestination(icon: Icon(Icons.favorite), label: 'Favorites'),
        ],
      ),
    );
  }
}
