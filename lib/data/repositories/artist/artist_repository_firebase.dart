import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../model/artist/artist.dart';
import '../../../model/comment/comment.dart';
import '../../../model/songs/song.dart';
import '../../dtos/artist_dto.dart';
import '../../dtos/comment_dto.dart';
import '../../dtos/song_dto.dart';
import 'artist_repository.dart';

class ArtistRepositoryFirebase implements ArtistRepository {
  static const String _host =
      'flutter-lab-6dcc4-default-rtdb.asia-southeast1.firebasedatabase.app';

  final Uri artistsUri = Uri.https(_host, '/artists.json');

  List<Artist>? _cachedArtists;

  @override
  Future<List<Artist>> fetchArtists({bool forceFetch = false}) async {
    // 1- Return cache if available
    if (!forceFetch && _cachedArtists != null) {
      return _cachedArtists!;
    }

    // 2- Otherwise fetch from API
    final http.Response response = await http.get(artistsUri);

    if (response.statusCode == 200) {
      Map<String, dynamic> artistJson = json.decode(response.body);

      List<Artist> result = [];
      for (final entry in artistJson.entries) {
        result.add(ArtistDto.fromJson(entry.key, entry.value));
      }

      // 3- Store in memory
      _cachedArtists = result;
      return result;
    } else {
      throw Exception('Failed to load artists');
    }
  }

  @override
  Future<Artist?> fetchArtistById(String id) async {
    final artists = await fetchArtists();
    return artists.where((a) => a.id == id).firstOrNull;
  }

  @override
  Future<List<Song>> fetchArtistSongs(String artistId) async {
    final uri = Uri.https(_host, '/songs.json', {
      'orderBy': '"artistId"',
      'equalTo': '"$artistId"',
    });
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data == null) return [];

      final Map<String, dynamic> songJson = data;
      List<Song> result = [];
      for (final entry in songJson.entries) {
        result.add(SongDto.fromJson(entry.key, entry.value));
      }
      return result;
    } else {
      throw Exception('Failed to load artist songs');
    }
  }

  @override
  Future<List<Comment>> fetchArtistComments(String artistId) async {
    final uri = Uri.https(_host, '/comments.json', {
      'orderBy': '"artistId"',
      'equalTo': '"$artistId"',
    });
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data == null) return [];

      final Map<String, dynamic> commentJson = data;
      List<Comment> result = [];
      for (final entry in commentJson.entries) {
        result.add(CommentDto.fromJson(entry.key, entry.value));
      }
      // Sort by newest first
      result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return result;
    } else {
      throw Exception('Failed to load comments');
    }
  }

  @override
  Future<Comment> postComment(String artistId, String text) async {
    final uri = Uri.https(_host, '/comments.json');
    final comment = Comment(
      id: '',
      artistId: artistId,
      text: text,
      createdAt: DateTime.now(),
    );

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(CommentDto.toJson(comment)),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = json.decode(response.body);
      final String newId = body['name'];
      return Comment(
        id: newId,
        artistId: artistId,
        text: text,
        createdAt: comment.createdAt,
      );
    } else {
      throw Exception('Failed to post comment (${response.statusCode})');
    }
  }
}
