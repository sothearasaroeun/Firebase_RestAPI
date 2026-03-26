import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../model/artists/artist.dart';
import '../../dtos/artist_dto.dart';
import 'artist_repository.dart';

class ArtistRepositoryFirebase extends ArtistRepository {
  static final Uri baseUri = Uri.https(
    'week8-practice-16a27-default-rtdb.asia-southeast1.firebasedatabase.app',
  );
  static final Uri artistsUri = baseUri.replace(path: '/artists.json');

  @override
  Future<List<Artist>> fetchArtists() async {
    final response = await http.get(artistsUri);

    if (response.statusCode == 200) {
      Map<String, dynamic> artistJson = json.decode(response.body);
      List<Artist> artists = [];

      for (var it in artistJson.entries) {
        String id = it.key;
        Map<String, dynamic> value = it.value;
        Artist artist = ArtistDto.fromJson(id, value);
        artists.add(artist);
      }
      return artists;
    } else {
      throw Exception('Failed to load artists');
    }
  }
  
  @override
  Future<Artist?> fetchArtistsById(String id) async {}
}