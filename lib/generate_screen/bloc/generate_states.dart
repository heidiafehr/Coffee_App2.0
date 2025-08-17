import 'package:equatable/equatable.dart';

abstract class GenerateState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ImageLoading extends GenerateState {}

class ImageLoaded extends GenerateState {
  ImageLoaded(this.imageUrl, {this.isFavorited = false});

  final String imageUrl;
  final bool isFavorited;
  
  @override
  List<Object?> get props => [imageUrl];
}

class ImageError extends GenerateState {
  ImageError(this.errorMessage);

  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}