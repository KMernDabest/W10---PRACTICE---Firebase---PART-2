import 'dart:convert';

import 'package:http/http.dart' as http;
 
import '../../../model/artist/artist.dart';
import '../../dtos/artist_dto.dart';
import 'artist_repository.dart';

class ArtistRepositoryFirebase implements ArtistRepository {
  final Uri artistsUri = Uri.https(
    'flutter-lab-6dcc4-default-rtdb.asia-southeast1.firebasedatabase.app',
    '/artists.json',
  );

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
  Future<Artist?> fetchArtistById(String id) async {}
}
