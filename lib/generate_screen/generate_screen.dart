import 'package:coffee_app_2/generate_screen/bloc/generate_bloc.dart';
import 'package:coffee_app_2/generate_screen/bloc/generate_events.dart';
import 'package:coffee_app_2/generate_screen/bloc/generate_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GenerateScreen extends StatefulWidget {
  const GenerateScreen({super.key});

  @override
  State<GenerateScreen> createState() => _GenerateScreenState();
}

class _GenerateScreenState extends State<GenerateScreen> {
  @override
  Widget build(BuildContext context) {
    final generateBloc = context.read<GenerateBloc>();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BlocBuilder<GenerateBloc, GenerateState>(
            builder: (context, state) {
              if (state is ImageLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ImageLoaded) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Stack(
                        children: [
                          AspectRatio(
                            aspectRatio: 1,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                state.imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: ElevatedButton(
                              onPressed: () async {
                                generateBloc.add(
                                  ToggleFavoritesItem(
                                    state.imageUrl,
                                    isFavorited: !state.isFavorited,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                iconColor: state.isFavorited
                                    ? Colors.red
                                    : Colors.grey,
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(12),
                              ),
                              child: Icon(Icons.favorite),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () => generateBloc.add(LoadImage()),
                        child: Icon(Icons.refresh_rounded),
                      ),
                    ),
                  ],
                );
              } else if (state is ImageError) {
                return Text('uh oh there is an error loading the image');
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
