import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unsplash_bloc/src/models/Photo.dart';
import 'package:unsplash_bloc/src/utils/ScreenSizes.dart';
import 'package:unsplash_bloc/src/views/home/pages/popular/popular.bloc.dart';
import 'package:unsplash_bloc/src/widgets/PhotoWrapper.dart';

class PopularPage extends StatefulWidget {
  @override
  _PopularPageState createState() => _PopularPageState();
}

class _PopularPageState extends State<PopularPage>
    with AutomaticKeepAliveClientMixin<PopularPage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      child: BlocProvider(
        create: (context) => PopularBloc()..add(PopularEvent()),
        child: LatestContent(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

// ignore: must_be_immutable
class LatestContent extends StatelessWidget {
  final ScrollController controller = ScrollController();
  PopularBloc bloc = PopularBloc();

  void onScroll() {
    double maxScroll = controller.position.maxScrollExtent;
    double currentScroll = controller.position.pixels;

    if (currentScroll == maxScroll) bloc.add(PopularEvent());
  }

  Widget _pictureListBuilder(
      List<Photo> photos, int photosLength, bool hasReachedMax) {
    return ListView.builder(
      padding: EdgeInsets.only(top: Sizes.s20),
      controller: controller,
      itemCount: hasReachedMax ? photosLength : photosLength + 1,
      itemBuilder: (context, index) {
        Photo photo = index >= photosLength ? Photo() : photos[index];
        // if index is small than length, process data
        return index < photosLength
            ? PhotoWrapper(photo: photo)
            : Container(
                height: Sizes.s80,
                width: double.infinity,
                child: Center(
                  child: CupertinoActivityIndicator(),
                ),
              );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<PopularBloc>(context);
    controller.addListener(onScroll);
    return BlocListener<PopularBloc, PopularState>(
      listener: (context, state) {
        if (state is PopularError) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
      },
      child: BlocBuilder<PopularBloc, PopularState>(
        builder: (context, state) {
          if (state is PopularUninitialized) {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          } else if (state is PopularLoaded) {
            PopularLoaded popularLoaded = state;
            int photosLength = popularLoaded.photos.length;

            return _pictureListBuilder(
              popularLoaded.photos,
              photosLength,
              popularLoaded.hasReachedMax,
            );
          } else {
            return Center(
              child: Text(
                "Unknown state",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
