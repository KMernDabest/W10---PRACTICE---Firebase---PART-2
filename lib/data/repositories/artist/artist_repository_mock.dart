import '../../../model/artist/artist.dart';
import '../../../model/comment/comment.dart';
import '../../../model/songs/song.dart';
import 'artist_repository.dart';

class ArtistRepositoryMock implements ArtistRepository {
  final List<Artist> _artists = [];

  @override
  Future<List<Artist>> fetchArtists({bool forceFetch = false}) async {
    return Future.delayed(Duration(seconds: 4), () {
      throw _artists;
    });
  }

  @override
  Future<Artist?> fetchArtistById(String id) async {
    return Future.delayed(Duration(seconds: 4), () {
      return _artists.firstWhere(
        (artist) => artist.id == id,
        orElse: () => throw Exception("No artist with id $id in the database"),
      );
    });
  }

  @override
  Future<List<Song>> fetchArtistSongs(String artistId) async {
    return Future.delayed(Duration(seconds: 1), () => []);
  }

  @override
  Future<List<Comment>> fetchArtistComments(String artistId) async {
    return Future.delayed(Duration(seconds: 1), () => []);
  }

  @override
  Future<Comment> postComment(String artistId, String text) async {
    return Future.delayed(Duration(seconds: 1), () {
      return Comment(
        id: 'mock_id',
        artistId: artistId,
        text: text,
        createdAt: DateTime.now(),
      );
    });
  }
}
