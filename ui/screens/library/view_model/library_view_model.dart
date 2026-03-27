import 'package:firebase_project/data/repositories/artists/artist_repository.dart';
import 'package:flutter/material.dart';
import '../../../../data/repositories/songs/song_repository.dart';
import '../../../../model/artists/artist.dart';
import '../../../states/player_state.dart';
import '../../../../model/songs/song.dart';
import '../../../utils/async_value.dart';

class LibraryViewModel extends ChangeNotifier {
  final SongRepository songRepository;
  final PlayerState playerState;
  final ArtistRepository artistRepository;

  AsyncValue<List<Song>> songsValue = AsyncValue.loading();

  LibraryViewModel({
    required this.songRepository,
    required this.playerState,
    required this.artistRepository,
  }) {
    playerState.addListener(notifyListeners);

    // init
    _init();
  }

  @override
  void dispose() {
    playerState.removeListener(notifyListeners);
    super.dispose();
  }

  void _init() async {
    fetchSong();
  }

  void fetchSong() async {
    // 1- Loading state
    songsValue = AsyncValue.loading();
    notifyListeners();

    try {
      final artists = await artistRepository.fetchArtists();
      final Map<String, Artist> artistMap = {};
      for (var artist in artists) {
        artistMap[artist.id] = artist;
      }

      final rawSongs = await songRepository.fetchSongs();

      final newSongs = rawSongs.map((song) {
        final artist = artistMap[song.artistId];
        return Song(
          id: song.id,
          title: song.title,
          artistId: song.artistId,
          duration: song.duration,
          imageUrl: song.imageUrl,
          artistName: artist?.name,
          artistGenre: artist?.genre,
        );
      }).toList();

      songsValue = AsyncValue.success(newSongs);

    } catch (e) {
      songsValue = AsyncValue.error(e);
    }
    notifyListeners();
  }

  bool isSongPlaying(Song song) => playerState.currentSong == song;

  void start(Song song) => playerState.start(song);
  void stop(Song song) => playerState.stop();
}
