import 'package:flutter/material.dart';
import '../../../../data/repositories/artist/artist_repository.dart';
import '../../../../model/artist/artist.dart';
import '../../../../model/comment/comment.dart';
import '../../../../model/songs/song.dart';
import '../../../utils/async_value.dart';

class ArtistDetailViewModel extends ChangeNotifier {
  final ArtistRepository artistRepository;
  final Artist artist;

  AsyncValue<List<Song>> songs = AsyncValue.loading();
  AsyncValue<List<Comment>> comments = AsyncValue.loading();

  ArtistDetailViewModel({
    required this.artistRepository,
    required this.artist,
  }) {
    _init();
  }

  void _init() {
    fetchData();
  }

  void fetchData() async {
    songs = AsyncValue.loading();
    comments = AsyncValue.loading();
    notifyListeners();

    try {
      final fetchedSongs = await artistRepository.fetchArtistSongs(artist.id);
      songs = AsyncValue.success(fetchedSongs);
    } catch (e) {
      songs = AsyncValue.error(e);
    }

    try {
      final fetchedComments =
          await artistRepository.fetchArtistComments(artist.id);
      comments = AsyncValue.success(fetchedComments);
    } catch (e) {
      comments = AsyncValue.error(e);
    }

    notifyListeners();
  }

  void addComment(String text, {VoidCallback? onError}) async {
    try {
      final newComment =
          await artistRepository.postComment(artist.id, text);

      // Update local state
      comments = comments.whenData(
        (list) => [newComment, ...list],
      );
    } catch (e) {
      onError?.call();
    }

    notifyListeners();
  }
}
