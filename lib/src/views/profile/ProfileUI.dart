import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:unsplash_bloc/src/models/Photo.dart';
import 'package:unsplash_bloc/src/utils/ScreenSizes.dart';
import 'package:unsplash_bloc/src/views/photo/PhotoUI.dart';
import 'package:unsplash_bloc/src/views/profile/profile.bloc.dart';
import 'package:unsplash_bloc/src/views/profile/userphoto.bloc.dart';
import 'package:unsplash_bloc/src/widgets/ProfileWrapper.dart';

class ProfileUI extends StatefulWidget {
  final String username;
  ProfileUI({@required this.username});
  @override
  _ProfileUIState createState() => _ProfileUIState();
}

class _ProfileUIState extends State<ProfileUI>
    with AutomaticKeepAliveClientMixin<ProfileUI> {
  final ScrollController controller = ScrollController();
  UserPhotosBloc userPhotosBloc = UserPhotosBloc();

  void onScroll() {
    // print(">> SCROLLING");
    double maxScroll = controller.position.maxScrollExtent;
    double currentScroll = controller.position.pixels;

    // print(currentScroll);
    if (currentScroll == maxScroll)
      userPhotosBloc.add(UserPhotosRequested(username: widget.username));
  }

  @override
  Widget build(BuildContext context) {
    controller.addListener(onScroll);
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.username}"),
      ),
      body: Container(
          width: double.maxFinite,
          height: double.maxFinite,
          child: MultiBlocProvider(
            providers: [
              BlocProvider<ProfileBloc>(
                create: (context) => ProfileBloc()
                  ..add(ProfileEventRequested(username: widget.username)),
              ),
              BlocProvider<UserPhotosBloc>(
                create: (context) => userPhotosBloc
                  ..add(UserPhotosRequested(username: widget.username)),
              ),
            ],
            child: ListView(
              controller: controller,
              children: <Widget>[Profile(), UserPhotos()],
            ),
          )),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

// ignore: must_be_immutable
class Profile extends StatelessWidget {
  // ignore: close_sinks
  ProfileBloc bloc = ProfileBloc();

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<ProfileBloc>(context);
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileError) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileUninitialized) {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          } else if (state is ProfileLoaded) {
            ProfileLoaded profileLoaded = state;
            return ProfileWrapper(user: profileLoaded.user);
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

// ignore: must_be_immutable
class UserPhotos extends StatelessWidget {
  // ignore: close_sinks
  UserPhotosBloc bloc = UserPhotosBloc();

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<UserPhotosBloc>(context);
    // controller.addListener(onScroll);
    return BlocListener<UserPhotosBloc, UserPhotosState>(
      listener: (context, state) {
        if (state is UserPhotosError) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
      },
      child: BlocBuilder<UserPhotosBloc, UserPhotosState>(
        builder: (context, state) {
          if (state is UserPhotosUninitialized) {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          } else if (state is UserPhotosLoaded) {
            UserPhotosLoaded photosLoaded = state;
            int photosLength = photosLoaded.photos.length;

            return StaggeredGridView.countBuilder(
              // physics: ScrollPhysics(),
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.only(left: Sizes.s10, right: Sizes.s10),
              crossAxisCount: 4,
              // itemCount: photosLength, //staticData.length,
              itemCount:
                  photosLoaded.hasReachedMax ? photosLength : photosLength + 1,
              itemBuilder: (context, index) {
                // Photo photo = photosLoaded.photos[index];
                Photo photo = index >= photosLength
                    ? Photo()
                    : photosLoaded.photos[index];
                return index < photosLength
                    ? Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(Sizes.s15)),
                        elevation: 8.0,
                        child: InkWell(
                          child: Hero(
                            tag: index, // staticData[index].images,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(Sizes.s15),
                              child: FadeInImage.assetNetwork(
                                width: MediaQuery.of(context).size.width,
                                image: "${photo.urls.regular}",
                                fit: BoxFit.cover,
                                placeholder: "assets/images/image.png",
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PhotoUI(
                                  id: photo.id,
                                  title: photo.altDescription ?? "",
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Container(
                        height: Sizes.s80,
                        width: double.infinity,
                        child: Center(
                          child: CupertinoActivityIndicator(),
                        ),
                      );
              },
              staggeredTileBuilder: (index) =>
                  StaggeredTile.count(2, index.isEven ? 2 : 3),
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
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
