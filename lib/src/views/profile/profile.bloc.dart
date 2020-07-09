import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unsplash_bloc/src/models/Photo.dart';
import 'package:unsplash_bloc/src/services/UnsplashService.dart';
import 'package:unsplash_bloc/src/utils/Helper.dart';

class ProfileEvent {}

class ProfileEventRequested extends ProfileEvent {
  final String username;
  ProfileEventRequested({this.username});
}

abstract class ProfileState {}

class ProfileUninitialized extends ProfileState {}

class ProfileError extends ProfileState {
  final String error;

  ProfileError({this.error});

  ProfileError copyWith({String error}) {
    return ProfileError(error: error ?? this.error);
  }
}

class ProfileLoaded extends ProfileState {
  final User user;
  ProfileLoaded({this.user});

  ProfileLoaded copyWith({User user}) {
    return ProfileLoaded(user: user ?? this.user);
  }
}

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UnsplashService _service = UnsplashService();

  @override
  ProfileState get initialState => ProfileUninitialized();

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is ProfileEventRequested) {
      if (state is ProfileUninitialized) {
        var result = await _service.userProfile(event.username);
        if (result.code == Status.success) {
          yield ProfileLoaded(user: result.data);
        } else {
          yield ProfileError(error: result.message);
        }
      }
    }
  }
}
