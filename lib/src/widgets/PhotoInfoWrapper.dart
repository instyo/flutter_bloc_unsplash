import 'package:flutter/material.dart';
import 'package:unsplash_bloc/src/models/Photo.dart';
import 'package:unsplash_bloc/src/utils/Theme.dart';

class PhotoInfoWrapper extends StatelessWidget {
  final Photo photo;
  PhotoInfoWrapper({@required this.photo});

  @override
  Widget build(BuildContext context) {
    final color = ThemeColor();

    return Container(
      decoration: BoxDecoration(
          color: color.darkShadeColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))),
      child: Wrap(
        children: <Widget>[
          ListTile(
            title: Text("${photo.likes}"),
            subtitle: Text("Likes"),
            trailing: Icon(Icons.favorite_border),
          ),
          ListTile(
            title: Text("${photo.downloads}"),
            subtitle: Text("Downloads"),
            trailing: Icon(Icons.file_download),
          ),
          ListTile(
            title: Text("${photo.exif.aperture}"),
            subtitle: Text("Aperture"),
          ),
          ListTile(
            title: Text("${photo.exif.exposureTime}"),
            subtitle: Text("Exposure Time"),
          ),
          ListTile(
            title: Text("${photo.exif.focalLength}"),
            subtitle: Text("Focal Length"),
          ),
          ListTile(
            title: Text("${photo.exif.iso}"),
            subtitle: Text("ISO"),
          ),
          ListTile(
            title: Text("${photo.exif.make}"),
            subtitle: Text("Make"),
          ),
          ListTile(
            title: Text("${photo.exif.model}"),
            subtitle: Text("Model"),
          ),
        ],
      ),
    );
  }
}
