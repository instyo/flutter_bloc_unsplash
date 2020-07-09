import 'package:flutter/material.dart';
import 'package:unsplash_bloc/src/models/Photo.dart';
import 'package:unsplash_bloc/src/utils/ScreenSizes.dart';
import 'package:unsplash_bloc/src/utils/Theme.dart';
import 'package:unsplash_bloc/src/views/photo/PhotoUI.dart';
import 'package:unsplash_bloc/src/views/profile/ProfileUI.dart';

class PhotoWrapper extends StatelessWidget {
  final color = ThemeColor();
  final Photo photo;

  PhotoWrapper({@required this.photo});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(left: Sizes.s10, right: Sizes.s10, bottom: Sizes.s15),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(Sizes.s10),
          ),
        ),
        color: color.darkShadeColor,
        child: Container(
          height: Sizes.s320,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProfileUI(username: "${photo.user.username}"),
                    ),
                  );
                },
                contentPadding: EdgeInsets.only(
                  left: Sizes.s10,
                  right: Sizes.s10,
                ),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                    photo.user.profileImage.medium,
                  ),
                  backgroundColor: color.backgroundColor,
                ),
                title: Text(
                  "${photo.user.username}",
                  style: color.white(),
                ),
                subtitle: Row(
                  children: <Widget>[
                    Icon(
                      Icons.location_on,
                      size: FontSize.s12,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Flexible(
                      child: Text(
                        "${photo.user.location != null ? photo.user.location : 'No Location'}",
                        style: color.subtitleWrapper(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(Icons.bookmark_border),
                  onPressed: () {},
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: Sizes.s10,
                  right: Sizes.s10,
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Text(
                          "${photo.altDescription}",
                          style: color.imageTitle(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        Icons.favorite_border,
                        color: Colors.white,
                        size: Sizes.s12,
                      ),
                      Text(
                        " ${photo.likes}",
                        style: color.white(),
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
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
                child: Container(
                  margin: EdgeInsets.fromLTRB(
                      Sizes.s10, Sizes.s15, Sizes.s10, Sizes.s10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(Sizes.s15)),
                    child: FadeInImage(
                      height: Sizes.s200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: ExactAssetImage("assets/images/image.png"),
                      image: NetworkImage("${photo.urls.small}"),
                    ),
                  ),
                ),
              )
            ],
          ),
          // decoration: BoxDecoration(color: color.darkShadeColor),
        ),
      ),
    );
  }
}
