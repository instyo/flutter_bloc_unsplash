import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unsplash_bloc/src/models/Photo.dart';
import 'package:unsplash_bloc/src/utils/ScreenSizes.dart';
import 'package:unsplash_bloc/src/views/home/pages/latest/latest.bloc.dart';
import 'package:unsplash_bloc/src/widgets/PhotoWrapper.dart';

class LatestPage extends StatefulWidget {
  @override
  _LatestPageState createState() => _LatestPageState();
}

class _LatestPageState extends State<LatestPage>
    with AutomaticKeepAliveClientMixin<LatestPage> {
  @override
  Widget build(BuildContext context) {
    super.build(context); // need to call super method.
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      child: BlocProvider(
        create: (context) => LatestBloc()..add(LatestEvent()),
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
  LatestBloc bloc = LatestBloc();

  void onScroll() {
    double maxScroll = controller.position.maxScrollExtent;
    double currentScroll = controller.position.pixels;

    if (currentScroll == maxScroll) bloc.add(LatestEvent());
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
    bloc = BlocProvider.of<LatestBloc>(context);
    controller.addListener(onScroll);
    return BlocListener<LatestBloc, LatestState>(
      listener: (context, state) {
        if (state is LatestError) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
      },
      child: BlocBuilder<LatestBloc, LatestState>(
        builder: (context, state) {
          if (state is LatestUninitialized) {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          } else if (state is LatestLoaded) {
            LatestLoaded latestLoaded = state;
            int photosLength = latestLoaded.photos.length;

            return _pictureListBuilder(
              latestLoaded.photos,
              photosLength,
              latestLoaded.hasReachedMax,
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
