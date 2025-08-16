import 'package:coffee_app_2/generate_screen/bloc/generate_bloc.dart';
import 'package:coffee_app_2/generate_screen/bloc/generate_event.dart';
import 'package:coffee_app_2/page_container_with_nav/page_container_with_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoffeeApp2 extends StatelessWidget {
  const CoffeeApp2({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [BlocProvider(create: (_) => GenerateBloc()..add(LoadImage()))],
        child: PageContainerWithNav(),
      ),
    );
  }
}
