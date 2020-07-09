import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unsplash_bloc/src/models/Photo.dart';
import 'package:unsplash_bloc/src/services/UnsplashService.dart';
import 'package:unsplash_bloc/src/utils/Helper.dart';

class LatestEvent {}

abstract class LatestState {}

class LatestUninitialized extends LatestState {}

class LatestError extends LatestState {
  final String error;

  LatestError({this.error});

  LatestError copyWith({String error}) {
    return LatestError(error: error ?? this.error);
  }
}

class LatestLoaded extends LatestState {
  List<Photo> photos;
  bool hasReachedMax;
  int currentPage = 1;

  LatestLoaded({
    this.photos,
    this.hasReachedMax,
    this.currentPage,
  });

  LatestLoaded copyWith({
    List<Photo> photos,
    bool hasReachedMax,
    int currentPage,
  }) {
    return LatestLoaded(
      photos: photos ?? this.photos,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

class LatestBloc extends Bloc<LatestEvent, LatestState> {
  final UnsplashService _service = UnsplashService();
  final String _order = "latest";

  @override
  LatestState get initialState => LatestUninitialized();

  @override
  Stream<LatestState> mapEventToState(LatestEvent event) async* {
    if (state is LatestUninitialized) {
      var result = await _service.photoList("$_order", 1);
      if (result.code == Status.success) {
        yield LatestLoaded(
          photos: result.data,
          hasReachedMax: false,
          currentPage: 1,
        );
      } else {
        yield LatestError(error: result.message);
      }
    } else if (state is LatestLoaded) {
      LatestLoaded latestLoaded = state as LatestLoaded;
      List<Photo> photos;
      // if photo infinite scroll has reached maximum value, then no request api needed
      if (latestLoaded.hasReachedMax) {
        return;
      } else {
        var result =
            await _service.photoList("$_order", latestLoaded.currentPage += 1);
        if (result.code == Status.success) {
          photos = result.data;
          yield photos.length < 1
              ? latestLoaded.copyWith(hasReachedMax: true)
              : LatestLoaded(
                  hasReachedMax: false,
                  photos: latestLoaded.photos + photos,
                  currentPage: latestLoaded.currentPage += 1);
        } else {
          yield LatestError(error: result.message);
        }
      }
    }
  }
}
