import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unsplash_bloc/src/models/Photo.dart';
import 'package:unsplash_bloc/src/utils/ScreenSizes.dart';
import 'package:unsplash_bloc/src/utils/Theme.dart';
import 'package:unsplash_bloc/src/views/photo/photo.bloc.dart';
import 'package:unsplash_bloc/src/views/profile/ProfileUI.dart';
import 'package:unsplash_bloc/src/widgets/CustomButton.dart';
import 'package:unsplash_bloc/src/widgets/PhotoInfoWrapper.dart';
import 'package:unsplash_bloc/src/widgets/TextIcon.dart';

class PhotoUI extends StatelessWidget {
  final String id;
  final String title;
  PhotoUI({this.id, this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$title"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocProvider(
        create: (context) => PhotoBloc()..add(PhotoEventRequested(id: id)),
        child: PhotoBody(),
      ),
    );
  }
}

// ignore: must_be_immutable
class PhotoBody extends StatelessWidget {
  // ignore: close_sinks
  PhotoBloc bloc = PhotoBloc();
  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<PhotoBloc>(context);
    return BlocListener<PhotoBloc, PhotoState>(
      listener: (context, state) {
        if (state is PhotoError) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
      },
      child: BlocBuilder<PhotoBloc, PhotoState>(
        builder: (context, state) {
          if (state is PhotoUninitialized) {
            return Center(
              child: CupertinoActivityIndicator(),
            );
          } else if (state is PhotoLoaded) {
            PhotoLoaded photoLoaded = state;
            return PhotoDetail(photo: photoLoaded.photo);
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

class PhotoDetail extends StatelessWidget {
  final color = ThemeColor();
  final Photo photo;
  PhotoDetail({@required this.photo});

  void _showInfo(BuildContext context, Photo photo) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext bc) {
          return PhotoInfoWrapper(photo: photo);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(Sizes.s15, 0, Sizes.s15, 0),
      height: double.maxFinite,
      width: double.maxFinite,
      child: ListView(
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.all(0),
            leading: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProfileUI(username: photo.user.username),
                  ),
                );
              },
              child: CircleAvatar(
                radius: Sizes.s20,
                backgroundImage: NetworkImage(
                  "${photo.user.profileImage.large}",
                ),
                backgroundColor: color.backgroundColor,
              ),
            ),
            title: Text(
              "${photo.user.name}",
              style: color.white(),
            ),
            subtitle: Text(
              "@${photo.user.username}",
              style: color.subtitleWrapper(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: InkWell(
              onTap: () {},
              child: Icon(Icons.share),
            ),
          ),
          Container(
              // height: double.infinity,
              // width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(Sizes.s15)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black54,
                        blurRadius: Sizes.s15,
                        offset: Offset(0.0, 0.75))
                  ]),
              child: Stack(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(Sizes.s15)),
                    child: Container(
                      child: Image.network(
                        "${photo.urls.full}",
                        fit: BoxFit.cover,
                      ),
                      // child:
                      // FadeInImage(
                      //   fit: BoxFit.contain,
                      //   placeholder: ExactAssetImage("assets/images/image.png"),
                      //   image: NetworkImage("${photo.urls.full}"),
                      // ),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        padding: EdgeInsets.only(right: Sizes.s15),
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(.3),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(Sizes.s15),
                              bottomRight: Radius.circular(Sizes.s15),
                            )),
                        height: Sizes.s40,
                        width: double.maxFinite,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            TextIcon(
                              icon: Icons.favorite_border,
                              text: "${photo.likes}",
                            ),
                            SizedBox(
                              width: Sizes.s10,
                            ),
                            TextIcon(
                              icon: Icons.vertical_align_bottom,
                              text: "${photo.downloads}",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )),
          SizedBox(
            height: Sizes.s10,
          ),
          Row(
            children: <Widget>[
              CustomButton(
                  icon: Icons.info_outline,
                  onTap: () {
                    _showInfo(context, photo);
                  }),
              Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      CustomButton(icon: Icons.file_download, onTap: null),
                      SizedBox(
                        width: Sizes.s15,
                      ),
                      CustomButton(icon: Icons.bookmark_border, onTap: null),
                    ],
                  ))
            ],
          )
        ],
      ),
    );
  }
}
