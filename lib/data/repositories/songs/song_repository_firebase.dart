import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../model/songs/song.dart';
import '../../dtos/song_dto.dart';
import 'song_repository.dart';

class SongRepositoryFirebase extends SongRepository {
  final Uri songsUri = Uri.https(
    'flutter-lab-6dcc4-default-rtdb.asia-southeast1.firebasedatabase.app',
    '/songs.json',
  );

  @override
  Future<List<Song>> fetchSongs() async {
    final http.Response response = await http.get(songsUri);

    if (response.statusCode == 200) {
      // 1 - Send the retrieved list of songs
      Map<String, dynamic> songJson = json.decode(response.body);

      List<Song> result = [];
      for (final entry in songJson.entries) {
        result.add(SongDto.fromJson(entry.key, entry.value));
      }
      return result;
    } else {
      // 2- Throw expcetion if any issue
      throw Exception('Failed to load posts');
    }
  }

  @override
  Future<Song?> fetchSongById(String id) async {}

  @override
  Future<Song> likeSong(String songId) async {
    // 1- Fetch the current song to get latest likes count
    final getUri = Uri.https(
      'flutter-lab-6dcc4-default-rtdb.asia-southeast1.firebasedatabase.app',
      '/songs/$songId.json',
    );
    final getResponse = await http.get(getUri);
    if (getResponse.statusCode != 200) {
      throw Exception('Failed to fetch song ($songId)');
    }
    final Map<String, dynamic> songJson = json.decode(getResponse.body);
    final int currentLikes = songJson[SongDto.likesKey] as int? ?? 0;

    // 2- PATCH with incremented likes
    final patchResponse = await http.patch(
      getUri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({SongDto.likesKey: currentLikes + 1}),
    );
    if (patchResponse.statusCode != 200) {
      throw Exception('Failed to update likes (${patchResponse.statusCode})');
    }

    // 3- Return the updated Song
    return SongDto.fromJson(songId, {
      ...songJson,
      SongDto.likesKey: currentLikes + 1,
    });
  }
}
