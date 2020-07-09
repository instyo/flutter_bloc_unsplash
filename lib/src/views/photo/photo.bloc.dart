import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unsplash_bloc/src/models/Photo.dart';
import 'package:unsplash_bloc/src/services/UnsplashService.dart';
import 'package:unsplash_bloc/src/utils/Helper.dart';

class PhotoEvent {}

class PhotoEventRequested extends PhotoEvent {
  final String id;
  PhotoEventRequested({this.id});
}

abstract class PhotoState {}

class PhotoUninitialized extends PhotoState {}

class PhotoError extends PhotoState {
  final String error;
  PhotoError({this.error});

  PhotoError copyWith({String error}) {
    return PhotoError(error: error ?? this.error);
  }
}

class PhotoLoaded extends PhotoState {
  final Photo photo;
  PhotoLoaded({this.photo});

  PhotoLoaded copyWith({Photo photo}) {
    return PhotoLoaded(photo: photo ?? this.photo);
  }
}

class PhotoBloc extends Bloc<PhotoEvent, PhotoState> {
  final UnsplashService _service = UnsplashService();

  @override
  PhotoState get initialState => PhotoUninitialized();

  @override
  Stream<PhotoState> mapEventToState(PhotoEvent event) async* {
    if (event is PhotoEventRequested) {
      if (state is PhotoUninitialized) {
        var result = await _service.photoDetail(event.id);
        if (result.code == Status.success) {
          yield PhotoLoaded(photo: result.data);
        } else {
          yield PhotoError(error: result.message);
        }
      }
    }
  }
}
