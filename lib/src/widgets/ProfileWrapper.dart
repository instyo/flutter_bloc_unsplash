import 'package:flutter/material.dart';
import 'package:unsplash_bloc/src/models/Photo.dart';
import 'package:unsplash_bloc/src/utils/Launcher.dart';
import 'package:unsplash_bloc/src/utils/ScreenSizes.dart';
import 'package:unsplash_bloc/src/utils/Theme.dart';
import 'package:unsplash_bloc/src/widgets/TextIcon.dart';

class ProfileWrapper extends StatelessWidget {
  final color = ThemeColor();
  final User user;
  ProfileWrapper({@required this.user});

  Widget _iconText(IconData icon, String title) {
    return Row(
      children: <Widget>[
        Icon(
          icon,
          size: FontSize.s17,
          color: Colors.grey[350],
        ),
        SizedBox(width: Sizes.s5),
        Text(
          "$title",
          style: TextStyle(
            fontSize: FontSize.s13,
            fontWeight: FontWeight.bold,
            color: Colors.grey[350],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: Sizes.s25,
        right: Sizes.s25,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.all(0),
            leading: CircleAvatar(
              radius: Sizes.s30,
              backgroundImage: NetworkImage(
                "${user.profileImage.large}",
              ),
              backgroundColor: color.backgroundColor,
            ),
            title: Text(
              "${user.username}",
              style: color.white(),
            ),
            subtitle: Text(
              user.location != null ? "${user.location}" : "No Location",
              style: color.subtitleWrapper(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: InkWell(
              onTap: () {
                if (user.portfolioUrl != null) {
                  Launcher.open(user.portfolioUrl);
                } else {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text("No Action Available!"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Icon(Icons.public),
            ),
          ),
          Text(
            user.bio != null ? "${user.bio}" : "",
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: FontSize.s12, color: Colors.grey[300]),
          ),
          SizedBox(
            height: Sizes.s15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              TextIcon(
                icon: Icons.bookmark_border,
                iconColor: Colors.grey[350],
                iconSize: FontSize.s17,
                text: "${user.totalPhotos}",
                textColor: Colors.grey[350],
                textSize: FontSize.s13,
                textWeight: FontWeight.bold,
              ),
              TextIcon(
                icon: Icons.favorite_border,
                iconColor: Colors.grey[350],
                iconSize: FontSize.s17,
                text: "${user.totalLikes}",
                textColor: Colors.grey[350],
                textSize: FontSize.s13,
                textWeight: FontWeight.bold,
              ),
              TextIcon(
                icon: Icons.person_outline,
                iconColor: Colors.grey[350],
                iconSize: FontSize.s17,
                text: "${user.followersCount}",
                textColor: Colors.grey[350],
                textSize: FontSize.s13,
                textWeight: FontWeight.bold,
              ),
            ],
          ),
          SizedBox(
            height: Sizes.s15,
          ),
        ],
      ),
    );
  }
}
