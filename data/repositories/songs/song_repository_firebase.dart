import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../model/songs/song.dart';
import '../../dtos/song_dto.dart';
import 'song_repository.dart';

class SongRepositoryFirebase extends SongRepository {
  static final Uri baseUri = Uri.https('week8-practice-16a27-default-rtdb.asia-southeast1.firebasedatabase.app');
  static final Uri songsUri = baseUri.replace(path: '/songs.json');

  @override
  Future<List<Song>> fetchSongs() async {
    final http.Response response = await http.get(songsUri);

    if (response.statusCode == 200) {
      // 1 - Send the retrieved list of songs
      Map<String, dynamic> songJson = json.decode(response.body);
      List<Song> songs = [];

      for (var it in songJson.entries) {
        String id = it.key;
        Map<String, dynamic> value = it.value;
        Song song = SongDto.fromJson(value, id);
        songs.add(song);
      }
      return songs;
    } else {
      // 2- Throw expcetion if any issue
      throw Exception('Failed to load posts');
    }
  }

  @override
  Future<Song?> fetchSongById(String id) async {}
}
