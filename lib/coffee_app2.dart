import 'package:coffee_app_2/favorites_screen/bloc/favorites_bloc.dart';
import 'package:coffee_app_2/favorites_screen/bloc/favorites_events.dart';
import 'package:coffee_app_2/generate_screen/bloc/generate_bloc.dart';
import 'package:coffee_app_2/generate_screen/bloc/generate_events.dart';
import 'package:coffee_app_2/page_container_with_nav/page_container_with_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class CoffeeApp2 extends StatelessWidget {
  const CoffeeApp2({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color.fromARGB(255, 250, 204, 166),
        textTheme: GoogleFonts.kodeMonoTextTheme(),
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => GenerateBloc()..add(LoadImage())),
          BlocProvider(
            create: (_) => FavoritesBloc()..add(LoadFavoritesCatalog()),
          ),
        ],
        child: PageContainerWithNav(),
      ),
    );
  }
}
