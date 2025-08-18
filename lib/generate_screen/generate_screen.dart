import 'package:cached_network_image/cached_network_image.dart';
import 'package:coffee_app_2/app_colors.dart';
import 'package:coffee_app_2/generate_screen/bloc/generate_bloc.dart';
import 'package:coffee_app_2/generate_screen/bloc/generate_events.dart';
import 'package:coffee_app_2/generate_screen/bloc/generate_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

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
                    Text(
                      'Generate\nCoffee Image',
                      style: GoogleFonts.bungee(
                        fontSize: 32,
                        color: AppColors.darkBrown,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsGeometry.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                      child: Text(
                        'Click the refresh button to get a new image or if you really like it click the heart to save it!',
                        style: GoogleFonts.kodeMono(
                          fontSize: 14,
                          color: AppColors.darkBrown,
                        ),
                      ),
                    ),
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
                                child: CachedNetworkImage(
                                  imageUrl: state.imageUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) => Icon(
                                    Icons.error,
                                    color: AppColors.darkBrown,
                                  ),
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
                              iconSize: 50.0,
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
                return Padding(
                  padding: EdgeInsetsGeometry.all(32),
                  child: Text(
                    'uh oh there is an error loading the image!\n\nMaybe you are not connected to the internet?\n\nHead over to the favorites tab and you can still see your favorite coffee images!',
                    textAlign: TextAlign.center,
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
