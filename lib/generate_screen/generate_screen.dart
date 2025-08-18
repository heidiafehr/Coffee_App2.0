import 'package:coffee_app_2/app_colors.dart';
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
                      padding: const EdgeInsets.all(20.0),
                      child: Stack(
                        children: [
                          AspectRatio(
                            aspectRatio: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppColors.darkBrown,
                                  width: 4,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.darkBrown,
                                    blurRadius: 0,
                                    offset: Offset(8, 8),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  state.imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 6,
                            right: 6,
                            child: IconButton(
                              icon: Icon(Icons.favorite),
                              onPressed: () async {
                                generateBloc.add(
                                  ToggleFavoritesItem(
                                    state.imageUrl,
                                    isFavorited: !state.isFavorited,
                                  ),
                                );
                              },
                              iconSize: 40.0,
                              color: state.isFavorited
                                  ? AppColors.lightRed
                                  : Colors.white.withValues(alpha: 0.4),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.cream,
                          border: Border.all(
                            color: AppColors.darkBrown,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.darkBrown,
                              offset: Offset(4, 4),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.refresh_rounded,
                            color: AppColors.darkBrown,
                          ),
                          iconSize: 28,
                          onPressed: () => generateBloc.add(LoadImage()),
                        ),
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
