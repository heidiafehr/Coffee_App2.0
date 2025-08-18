import 'package:coffee_app_2/app_colors.dart';
import 'package:coffee_app_2/favorites_screen/bloc/favorites_bloc.dart';
import 'package:coffee_app_2/favorites_screen/bloc/favorites_events.dart';
import 'package:coffee_app_2/favorites_screen/favorites_screen.dart';
import 'package:coffee_app_2/generate_screen/generate_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return [GenerateScreen(), FavoritesScreen()];
  }

  @override
  Widget build(BuildContext context) {
    final pages = _buildPages();

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.transparent,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });

          // reload page when selecting favorites
          if (index == 1) {
            context.read<FavoritesBloc>().add(LoadFavoritesCatalog());
          }
        },
        destinations: [
          NavigationDestination(
            icon: Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(12),
                color: _selectedIndex == 0 ? AppColors.darkBrown : AppColors.cream,
                border: Border.all(color: AppColors.darkBrown, width: 2),
                boxShadow: [
                  BoxShadow(color: AppColors.darkBrown, offset: Offset(4, 4)),
                ],
              ),
              child: Padding(
                padding: EdgeInsetsGeometry.all(12),
                child: Icon(
                  Icons.coffee_outlined,
                  color: _selectedIndex == 0 ? AppColors.cream : AppColors.darkBrown,
                  size: 40,
                ),
              ),
            ),
            label: 'Coffee',
          ),
          NavigationDestination(
            icon: Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(12),
                color: _selectedIndex == 1 ? AppColors.darkBrown : AppColors.cream,
                border: Border.all(color: AppColors.darkBrown, width: 2),
                boxShadow: [
                  BoxShadow(color: AppColors.darkBrown, offset: Offset(4, 4)),
                ],
              ),
              child: Padding(
                padding: EdgeInsetsGeometry.all(12),
                child: Icon(
                  Icons.favorite_border,
                  color: _selectedIndex == 1 ? AppColors.cream : AppColors.darkBrown,
                  size: 40,
                ),
              ),
            ),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}
