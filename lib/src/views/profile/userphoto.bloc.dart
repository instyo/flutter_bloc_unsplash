import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unsplash_bloc/src/models/Photo.dart';
import 'package:unsplash_bloc/src/services/UnsplashService.dart';
import 'package:unsplash_bloc/src/utils/Helper.dart';

class UserPhotosEvent {}

class UserPhotosRequested extends UserPhotosEvent {
  final String username;
  UserPhotosRequested({this.username});
}

abstract class UserPhotosState {}

class UserPhotosUninitialized extends UserPhotosState {}

class UserPhotosError extends UserPhotosState {
  final String error;

  UserPhotosError({this.error});

  UserPhotosError copyWith({String error}) {
    return UserPhotosError(error: error ?? this.error);
  }
}

class UserPhotosLoaded extends UserPhotosState {
  String username;
  List<Photo> photos;
  bool hasReachedMax;
  int currentPage = 1;

  UserPhotosLoaded({
    this.username,
    this.photos,
    this.hasReachedMax,
    this.currentPage,
  });

  UserPhotosLoaded copyWith({
    List<Photo> photos,
    bool hasReachedMax,
    int currentPage,
  }) {
    return UserPhotosLoaded(
      username: username ?? this.username,
      photos: photos ?? this.photos,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

class UserPhotosBloc extends Bloc<UserPhotosEvent, UserPhotosState> {
  final UnsplashService _service = UnsplashService();

  @override
  UserPhotosState get initialState => UserPhotosUninitialized();

  @override
  Stream<UserPhotosState> mapEventToState(UserPhotosEvent event) async* {
    if (event is UserPhotosRequested) {
      if (state is UserPhotosUninitialized) {
        var result = await _service.userPhotoList(event.username, 1);
        if (result.code == Status.success) {
          yield UserPhotosLoaded(
            photos: result.data,
            hasReachedMax: false,
            currentPage: 1,
          );
        } else {
          yield UserPhotosError(error: result.message);
        }
      } else if (state is UserPhotosLoaded) {
        UserPhotosLoaded userPhotosLoaded = state as UserPhotosLoaded;
        // if photo infinite scroll has reached maximum value, then no request api needed
        if (userPhotosLoaded.hasReachedMax) {
          return;
        } else {
          var result = await _service.userPhotoList(
            "${event.username}",
            userPhotosLoaded.currentPage += 1,
          );
          if (result.code == Status.success) {
            var photos = result.data;
            yield photos.length < 1
                ? userPhotosLoaded.copyWith(hasReachedMax: true)
                : UserPhotosLoaded(
                    hasReachedMax: false,
                    photos: userPhotosLoaded.photos + photos,
                    currentPage: userPhotosLoaded.currentPage += 1);
          } else {
            yield UserPhotosError(error: result.message);
          }
        }
      }
    }
  }
}
