import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/repositories/artist/artist_repository.dart';
import '../../../model/artist/artist.dart';
import 'view_model/artist_detail_view_model.dart';
import 'widgets/artist_detail_content.dart';

class ArtistDetailScreen extends StatelessWidget {
  const ArtistDetailScreen({super.key, required this.artist});

  final Artist artist;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ArtistDetailViewModel(
        artistRepository: context.read<ArtistRepository>(),
        artist: artist,
      ),
      child: ArtistDetailContent(),
    );
  }
}
