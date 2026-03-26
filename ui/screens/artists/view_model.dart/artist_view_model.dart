import 'package:firebase_project/data/repositories/artists/artist_repository.dart';
import 'package:firebase_project/model/artists/artist.dart';
import 'package:flutter/material.dart';
import '../../../utils/async_value.dart';

class ArtistViewModel extends ChangeNotifier {
  final ArtistRepository artistRepository;

  AsyncValue<List<Artist>> artistValue = AsyncValue.loading();

  ArtistViewModel(this.artistRepository) {
   _loadArtists();
  }

  Future<void>  _loadArtists() async {
    artistValue = AsyncValue.loading();
    notifyListeners();

    try {
      List<Artist> artists = await artistRepository.fetchArtists();
      artistValue = AsyncValue.success(artists);
    } catch (e) {
      artistValue = AsyncValue.error(e.toString());
    }
    notifyListeners();
  }
}