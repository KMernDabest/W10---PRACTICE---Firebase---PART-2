// song_repository_mock.dart

import '../../../model/songs/song.dart';
import 'song_repository.dart';

class SongRepositoryMock implements SongRepository {
  final List<Song> _songs = [  ];

  @override
  Future<List<Song>> fetchSongs({bool forceFetch = false}) async {
    return Future.delayed(Duration(seconds: 4), () {
      throw _songs;
    });
  }

  @override
  Future<Song?> fetchSongById(String id) async {
    return Future.delayed(Duration(seconds: 4), () {
      return _songs.firstWhere(
        (song) => song.id == id,
        orElse: () => throw Exception("No song with id $id in the database"),
      );
    });
  }

  @override
  Future<Song> likeSong(String songId) async {
    return Future.delayed(Duration(seconds: 1), () {
      final song = _songs.firstWhere(
        (song) => song.id == songId,
        orElse: () => throw Exception("No song with id $songId in the database"),
      );
      return song.copyWith(likes: song.likes + 1);
    });
  }
}
