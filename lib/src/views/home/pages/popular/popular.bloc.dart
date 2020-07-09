import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unsplash_bloc/src/models/Photo.dart';
import 'package:unsplash_bloc/src/services/UnsplashService.dart';
import 'package:unsplash_bloc/src/utils/Helper.dart';

class PopularEvent {}

abstract class PopularState {}

class PopularUninitialized extends PopularState {}

class PopularError extends PopularState {
  final String error;

  PopularError({this.error});

  PopularError copyWith({String error}) {
    return PopularError(error: error ?? this.error);
  }
}

class PopularLoaded extends PopularState {
  List<Photo> photos;
  bool hasReachedMax;
  int currentPage = 1;

  PopularLoaded({
    this.photos,
    this.hasReachedMax,
    this.currentPage,
  });

  PopularLoaded copyWith({
    List<Photo> photos,
    bool hasReachedMax,
    int currentPage,
  }) {
    return PopularLoaded(
      photos: photos ?? this.photos,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

class PopularBloc extends Bloc<PopularEvent, PopularState> {
  final UnsplashService _service = UnsplashService();
  final String _order = "popular";

  @override
  PopularState get initialState => PopularUninitialized();

  @override
  Stream<PopularState> mapEventToState(PopularEvent event) async* {
    if (state is PopularUninitialized) {
      var result = await _service.photoList("$_order", 1);
      if (result.code == Status.success) {
        yield PopularLoaded(
          photos: result.data,
          hasReachedMax: false,
          currentPage: 1,
        );
      } else {
        yield PopularError(error: result.message);
      }
    } else if (state is PopularLoaded) {
      PopularLoaded popularLoaded = state as PopularLoaded;
      List<Photo> photos;
      // if photo infinite scroll has reached maximum value, then no request api needed
      if (popularLoaded.hasReachedMax) {
        return;
      } else {
        var result =
            await _service.photoList("$_order", popularLoaded.currentPage += 1);
        if (result.code == Status.success) {
          photos = result.data;
          yield photos.length < 1
              ? popularLoaded.copyWith(hasReachedMax: true)
              : PopularLoaded(
                  hasReachedMax: false,
                  photos: popularLoaded.photos + photos,
                  currentPage: popularLoaded.currentPage += 1);
        } else {
          yield PopularError(error: result.message);
        }
      }
    }
  }
}
