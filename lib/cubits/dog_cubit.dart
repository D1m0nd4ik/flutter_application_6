import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../requests/api.dart';

abstract class DogState extends Equatable {
  const DogState();
}

class DogInitial extends DogState {
  @override
  List<Object?> get props => [];
}

class DogLoading extends DogState {
  @override
  List<Object?> get props => [];
}

class DogLoaded extends DogState {
  final List<String> imageUrls;

  const DogLoaded(this.imageUrls);

  @override
  List<Object?> get props => [imageUrls];
}

class DogError extends DogState {
  final String message;

  const DogError(this.message);

  @override
  List<Object?> get props => [message];
}

class DogCubit extends Cubit<DogState> {
  DogCubit() : super(DogInitial());

  Future<void> loadImages() async {
    emit(DogLoading());
    try {
      final urls = await fetchDogImages();
      emit(DogLoaded(urls));
    } catch (e) {
      emit(DogError(e.toString()));
    }
  }
}