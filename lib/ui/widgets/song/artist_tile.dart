import 'package:flutter/material.dart';
import '../../../model/artist/artist.dart';

class ArtistTile extends StatelessWidget {
  const ArtistTile({
    super.key,
    required this.artist,
    this.onTap,
  });

  final Artist artist;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: ListTile(
          onTap: onTap,
          title: Text(artist.name),
          subtitle: Text("Genre: ${artist.genre}"),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(artist.imageUrl.toString()),
          ),
        ),
      ),
    );
  }
}
